//
//  TrainingView.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 2/12/22.
//

import Charts
import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var model: MyViewModel
	@State private var dateSelection = 0
	let dateTitles = ["S", "M", "A"]
    @State private var dataTypeSelection = 0
    let dataTitles = ["dur. (min)", "long. (km)", "km/h", "kcal", "FC media"]
	
	var component: Calendar.Component {
		model.calcCalendarComponent(dates: dateSelection)
	}
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                	Picker("Fechas", selection: $dateSelection.animation()) {
						ForEach(0..<dateTitles.count, id: \.self) {
							Text(dateTitles[$0])
						}
					}
					Picker("Datos", selection: $dataTypeSelection.animation()) {
						ForEach(0..<dataTitles.count, id: \.self) {
							Text(dataTitles[$0])
						}
					}
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.horizontal)
                VStack(spacing: 20) {
                    GroupBox {
                        Text("Correr")
                        Chart(0..<model.runningDates(for: dateSelection).count, id: \.self) { index in
                            PointMark(
                                x: .value("Fecha", model.runningDates(for: dateSelection)[index], unit: component),
								y: .value("Duración", model.getRunningData(for: dateSelection, dataTypeSelection)[index])
                            )
                            .foregroundStyle(Color.orange.opacity(0.6))
                            LineMark(
                                x: .value("Fecha", model.runningDates(for: dateSelection)[index]),
								y: .value("Duración", model.getRunningData(for: dateSelection, dataTypeSelection)[index])
                            )
                            .foregroundStyle(Color.orange)
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    GroupBox {
                        Text("Caminar")
                        Chart(0..<model.walkingDates(for: dateSelection).count, id: \.self) { index in
                            PointMark(
                                x: .value("Fecha", model.walkingDates(for: dateSelection)[index]),
								y: .value("Duración", model.getWalkingData(for: dateSelection, dataTypeSelection)[index])
                            )
                            .foregroundStyle(Color.green.opacity(0.6))
                            LineMark(
                                x: .value("Fecha", model.walkingDates(for: dateSelection)[index]),
								y: .value("Duración", model.getWalkingData(for: dateSelection, dataTypeSelection)[index])
                            )
                            .foregroundStyle(Color.green)
                            .interpolationMethod(.catmullRom)
                        }
                    }
                    GroupBox {
                        ComplexDataView(dates: dateSelection, datas: dataTypeSelection)
                    }
                }
				.chartXAxis {
					switch dateSelection {
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
						default:
							AxisMarks(values: .stride(by: .day)) {
								AxisGridLine()
								AxisValueLabel(format: .dateTime.weekday(), centered: true)
							}
					}
				}
                .navigationTitle("Histórico por entrenamiento")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
            }
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView()
            .environmentObject(MyViewModel())
    }
}
