//
//  ExercisesViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-12.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Result
import ReactiveCocoa

class ExercisesViewModel {
    private let dataStore: DataStore
    private var exercises: [Exercise]
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
        self.exercises = [Exercise]()
    }
    
    func refreshSignalProducer() -> SignalProducer<Void, NSError> {
        return dataStore.exercisesProducer()
            .on(next: { exercises in self.exercises = exercises })
            .map { _ in () }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfExercisesInSection(section: Int) -> Int {
       return self.exercises.count
    }
    
    func exerciseSetGroupAtIndexPath(indexPath: NSIndexPath) -> Exercise {
        return self.exercises[indexPath.row]
    }
    
    func createExercise(name: String, muscles: [Muscle]) -> SignalProducer<Void, NSError> {
        let newExercise = Exercise(id: "", name: name, muscles: muscles)
        return dataStore.addExercise(newExercise)
            .on(next: {next in self.exercises.append(next) })
            .map { _ in () }
    }
}