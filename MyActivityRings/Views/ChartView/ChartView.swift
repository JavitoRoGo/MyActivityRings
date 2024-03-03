//
//  ChartView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import Charts
import SwiftUI

struct ChartView: View {
    @EnvironmentObject var model: MyViewModel
    let pickerText = ["S", "M", "A", "Total"]
    @State private var pickerSelection = 0
    
    var rings: [MyModel] {
        model.getDataForChart(dates: pickerSelection)
    }
    
    var component: Calendar.Component {
        model.calcCalendarComponent(dates: pickerSelection)
    }
    
    var body: some View {
        NavigationStack {
            if model.myRingsData.isEmpty {
                VStack {
                    Text("Añade algunos datos para")
                    Text("comenzar a usar la app...")
                }
                .font(.title)
            } else {
                VStack {
                    Picker("Intervalo de tiempo", selection: $pickerSelection.animation()) {
                        ForEach(0..<pickerText.count, id: \.self) {
                            Text(pickerText[$0])
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    VStack {
                        Chart(rings) { ring in
                            BarMark(
                                x: .value("Fecha", ring.date, unit: component),
                                y: .value("kcal", ring.movement)
                            )
                            .foregroundStyle(.pink)
                        }
                        Chart(rings) { ring in
                            BarMark(
                                x: .value("Fecha", ring.date, unit: component),
                                y: .value("minutos", ring.exercise)
                            )
                            .foregroundStyle(.green)
                        }
                        Chart(rings) { ring in
                            BarMark(
                                x: .value("Fecha", ring.date, unit: component),
                                y: .value("horas", ring.standUp)
                            )
                        }
                    }
                    .chartXAxis {
                        switch pickerSelection {
                        case 1:
                            AxisMarks(values: .stride(by: .day)) {
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.day(), centered: true)
                            }
                        case 2:
                            AxisMarks(values: .stride(by: .month)) {
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.month(), centered: true)
                            }
                        case 3:
                            AxisMarks(values: .stride(by: .year)) {
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.year(), centered: true)
                            }
                        default:
                            AxisMarks(values: .stride(by: .day)) {
                                AxisGridLine()
                                AxisValueLabel(format: .dateTime.weekday(), centered: true)
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("Histórico")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChartView()
                .environmentObject(MyViewModel())
        }
    }
}
