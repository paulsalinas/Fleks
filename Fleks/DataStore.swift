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
    func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, toWorkout workout: Workout) -> SignalProducer<Workout, NSError>
    func exerciseSetGroupsProducer(forWorkout workout: Workout) -> SignalProducer<[ExerciseSetGroup], NSError>
    
    func workoutProducer(forWorkoutId workoutId: String) -> SignalProducer<Workout, NSError>
    func workoutsProducer() -> SignalProducer<[Workout], NSError>
    func updateWorkout(workout: Workout) -> SignalProducer<Workout, NSError>
    func deleteWorkout(workout: Workout) -> SignalProducer<Workout, NSError>
    func addWorkout(workout: Workout) -> SignalProducer<Workout, NSError>
    
    func exercisesProducer() -> SignalProducer<[Exercise], NSError>
    func addExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError>
    func updateExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError>
    func deleteExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError>
    
    func musclesProducer() -> SignalProducer<[Muscle], NSError>
    var isOnline: MutableProperty<Bool> { get }
}
