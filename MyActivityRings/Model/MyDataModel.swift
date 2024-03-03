//
//  MyDataModel.swift
//  MyActivityRings
//
//  Created by Javier Rodríguez Gómez on 21/11/22.
//

import SwiftUI

struct MyModel: Codable, Identifiable {
    let id: UUID
    let date: Date
    let movement: Int
    let exercise: Int
    let standUp: Int
    let isTraining: Bool
    let training: Train?
    
    static let example = [
        MyModel(id: UUID(), date: Date.distantFuture, movement: 444, exercise: 44, standUp: 20, isTraining: true, training: Train.example),
        MyModel(id: UUID(), date: Date.distantFuture, movement: 11, exercise: 1, standUp: 1, isTraining: false, training: nil)
    ]
}

struct Train: Codable {
    let type: TrainingType
    let duration: TimeInterval
    let lenght: Double
    let calories: Int
    let meanHR: Int
    
    var velocity: Double {
        if duration == 0 {
            return 0.0
        }
        return lenght / duration * 60
    }
    
    static let example = Train(type: .toRun, duration: 180, lenght: 5.5, calories: 275, meanHR: 159)
}

enum TrainingType: String, Codable, CaseIterable, Identifiable {
    case toRun = "Correr"
    case toWalk = "Caminar"
    
    var id: String { rawValue }
}
