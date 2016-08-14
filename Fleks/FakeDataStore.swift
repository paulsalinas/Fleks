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


// For testing
class FakeDataStore: DataStore {
     func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, toWorkout workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(repetitions: repetitions, sets: sets, exercise: exercise, notes: notes)
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
    
    func workoutProducer(forWorkoutId workoutId: String) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(sets: [ExerciseSet](), notes: "tesT")
            let workout = Workout(id: "test", name: "test", exerciseSets: [exerciseSetGroup])
            observer.sendNext(workout)
        }
    }
    
    func workoutsProducer() -> SignalProducer<[Workout], NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(sets: [ExerciseSet](), notes: "tesT")
            let workouts = [Workout(id: "test", name: "test", exerciseSets: [exerciseSetGroup])]
            observer.sendNext(workouts)
        }
    }
    
    func updateWorkout(workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(sets: [ExerciseSet](), notes: "tesT")
            let workout = Workout(id: "test", name: "test", exerciseSets: [exerciseSetGroup])
            observer.sendNext(workout)
        }
    }
    
    func deleteWorkout(workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(sets: [ExerciseSet](), notes: "tesT")
            let workout = Workout(id: "test", name: "test", exerciseSets: [exerciseSetGroup])
            observer.sendNext(workout)
        }
    }

    func addWorkout(workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            let exerciseSetGroup =  ExerciseSetGroup(sets: [ExerciseSet](), notes: "tesT")
            let workout = Workout(id: "test", name: "test", exerciseSets: [exerciseSetGroup])
            observer.sendNext(workout)
        }
    }
    
    func exercisesProducer() -> SignalProducer<[Exercise], NSError> {
        return SignalProducer.init(value: [Exercise]())
    }
    
    func updateExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError> {
         return SignalProducer.init(value: Exercise(id: "test", name: "test", muscles: [Muscle]()))
    }
    
    func deleteExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError> {
        return SignalProducer.init(value: Exercise(id: "test", name: "test", muscles: [Muscle]()))
    }
    
    func addExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError> {
        return SignalProducer.init(value: Exercise(id: "test", name: "test", muscles: [Muscle]()))
    }
    
    func musclesProducer() -> SignalProducer<[Muscle], NSError> {
        return SignalProducer.init(value: [Muscle]())
    }
}
