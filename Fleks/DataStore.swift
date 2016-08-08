//
//  DataStore.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

protocol DataStore {
    func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, order: Int, toWorkout workout: Workout) throws -> SignalProducer<ExerciseSetGroup, NSError> 
}
