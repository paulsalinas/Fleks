//
//  FakeDataStore.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-08.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Result
import ReactiveCocoa

class FakeDataStore: DataStore {
     func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, toWorkout workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            let exerciseSets = (1...sets).map { _ in ExerciseSet(repetitions: repetitions, exercise: exercise) }
            let exerciseSetGroup =  ExerciseSetGroup(sets: exerciseSets, notes: notes)
            let workout = Workout(id: "test", name: "test", exerciseSets: [exerciseSetGroup])
            observer.sendNext(workout)
            
        }
    }
    
    func exerciseSetGroupsProducer(forWorkout workout: Workout) -> SignalProducer<[ExerciseSetGroup], NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(sets: [ExerciseSet](), notes: "tesT")
            observer.sendNext([exerciseSetGroup])
        }
    }
}
