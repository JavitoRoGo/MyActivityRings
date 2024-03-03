//
//  Prueba.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 4/12/22.
//

import Charts
import SwiftUI

struct ComplexData: Identifiable {
    let name: String
    let dates: [Date]
    let datas: [Double]
    var id: String {
        name
    }
}

struct ComplexDataView: View {
    @EnvironmentObject var model: MyViewModel
	let dates: Int
    let datas: Int
    
    var complexDatas: [ComplexData] {
		return [.init(name: "Correr", dates: model.runningDates(for: dates), datas: model.getRunningData(for: dates, datas)),
				.init(name: "Caminar", dates: model.walkingDates(for: dates), datas: model.getWalkingData(for: dates, datas))]
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Chart(complexDatas) { serie in
                ForEach(0..<serie.dates.count, id:\.self) { index in
                    PointMark(
                        x: .value("Fecha", serie.dates[index]),
                        y: .value("Valor", serie.datas[index])
                    )
                    .foregroundStyle(by: .value("Tipo", serie.name))
                    LineMark(
                        x: .value("Fecha", serie.dates[index]),
                        y: .value("Valor", serie.datas[index])
                    )
                    .foregroundStyle(by: .value("Tipo", serie.name))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartForegroundStyleScale(["Correr" : .orange, "Caminar" : .green])
        }
    }
}

struct Prueba_Previews: PreviewProvider {
    static var previews: some View {
        ComplexDataView(dates: 2, datas: 0)
            .environmentObject(MyViewModel())
    }
}
