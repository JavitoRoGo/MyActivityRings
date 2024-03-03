//
//  MyViewModel.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import SwiftUI

final class MyViewModel: ObservableObject {
    @Published var myRingsData: [MyModel] {
        didSet {
            saveToJson()
        }
    }
    
    init() {
        guard var url = Bundle.main.url(forResource: jsonFile, withExtension: nil),
              let directory = getDocumentDirectory() else {
            print("No se encuentra el archivo en el Bundle.")
            myRingsData = []
            return
        }
        let fileDocuments = directory.appendingPathComponent(jsonFile)
        if FileManager.default.fileExists(atPath: fileDocuments.path) {
            url = fileDocuments
            print("Carga inicial de datos desde archivo:\n\(fileDocuments.absoluteString).")
        } else {
            print("Carga inicial de datos desde Bundle.")
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([MyModel].self, from: jsonData)
            myRingsData = decodedData
            print("Datos cargados correctamente.")
        } catch (let error){
            print("Error al extraer los datos: \(error)")
            myRingsData = []
        }
    }
    
    func saveToJson() {
        guard let directory = getDocumentDirectory() else { return }
        let fileURL = directory.appendingPathComponent(jsonFile)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(myRingsData)
            try data.write(to: fileURL, options: .atomic)
            print("Grabación correcta")
            print(fileURL.absoluteString)
        } catch (let error){
            print("Error en la grabación \(error)")
        }
    }
    
    // FUNCIONES PARA LAS GRÁFICAS
    // Función para calcular Calendar.component
    func calcCalendarComponent(dates: Int) -> Calendar.Component {
        switch dates {
        case 1:
            return .day
        case 2:
            return .month
        case 3:
            return .year
        default:
            return .weekday
        }
    }
    
    // Función para obtener los datos de anillos a representar, y para las gráficas por entrenamiento
    func getDataForChart(dates: Int) -> [MyModel] {
		let mostRecentDate = myRingsData.first!.date
		var datas = [MyModel]()
		if dates == 0 {
			datas = myRingsData.filter { $0.date > mostRecentDate - 7.days }
		} else if dates == 1 {
			datas = myRingsData.filter { $0.date > mostRecentDate - 30.days }
		} else if dates == 2 {
			datas = myRingsData.filter { $0.date > mostRecentDate - 1.years }
		} else if dates == 3 {
			datas = myRingsData
		}
		
		return datas
    }
}

extension MyViewModel {
    // Extraer los datos de los entrenamientos
    
	func runningDates(for dates: Int) -> [Date] {
		let datas = getDataForChart(dates: dates)
        var array = [Date]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(ring.date, at: 0)
            }
        }
        return array
    }
	func walkingDates(for dates: Int) -> [Date] {
		let datas = getDataForChart(dates: dates)
        var array = [Date]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(ring.date, at: 0)
            }
        }
        return array
    }
    
	func runningDuration(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Double]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.duration, at: 0)
            }
        }
        return array
    }
	func walkingDuration(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Double]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.duration, at: 0)
            }
        }
        return array
    }
    
	func runningLength(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Double]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.lenght, at: 0)
            }
        }
        return array
    }
	func walkingLength(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Double]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.lenght, at: 0)
            }
        }
        return array
    }
    
	func runningCals(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Int]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.calories, at: 0)
            }
        }
        return array.map { Double($0) }
    }
	func walkingCals(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Int]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.calories, at: 0)
            }
        }
        return array.map { Double($0) }
    }
    
	func runningHR(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Int]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(training.meanHR, at: 0)
            }
        }
        return array.map { Double($0) }
    }
	func walkingHR(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Int]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(training.meanHR, at: 0)
            }
        }
        return array.map { Double($0) }
    }
    
	func runningVelocity(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Double]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toRun {
                array.insert(Double(training.velocity), at: 0)
            }
        }
        return array
    }
	func walkingVelocity(for dates: Int) -> [Double] {
		let datas = getDataForChart(dates: dates)
        var array = [Double]()
        datas.forEach { ring in
            if let training = ring.training, training.type == .toWalk {
                array.insert(Double(training.velocity), at: 0)
            }
        }
        return array
    }
    
    // Funciones para elegir los datos para la gráfica de entrenamientos
	func getRunningData(for dates: Int, _ datas: Int) -> [Double] {
        switch datas {
        case 1:
            return runningLength(for: dates)
        case 2:
			return runningVelocity(for: dates)
        case 3:
			return runningCals(for: dates)
        case 4:
			return runningHR(for: dates)
        default:
            return runningDuration(for: dates)
        }
    }
	func getWalkingData(for dates: Int, _ datas: Int) -> [Double] {
        switch datas {
        case 1:
            return walkingLength(for: dates)
        case 2:
			return walkingVelocity(for: dates)
        case 3:
			return walkingCals(for: dates)
        case 4:
			return walkingHR(for: dates)
        default:
            return walkingDuration(for: dates)
        }
    }
}


let jsonFile = "MYRINGDATA.json"

func getDocumentDirectory() -> URL? {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path.first
}
