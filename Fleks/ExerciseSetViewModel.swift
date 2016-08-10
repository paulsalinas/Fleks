//
//  ExerciseSetViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

enum ExerciseSetFormError: Equatable {
    case InvalidSet(String)
    case InvalidRep(String)
    case None
}

func ==(lhs: ExerciseSetFormError, rhs: ExerciseSetFormError) -> Bool {
    switch (lhs, rhs) {
    case (let .InvalidSet(msg1), let .InvalidSet(msg2)):
        return msg1 == msg2
    case (let .InvalidRep(msg1), let .InvalidRep(msg2)):
        return msg1 == msg2
    case (.None, .None):
        return true
    default:
        return false
    }
}


class ExerciseSetViewModel {
    
    let exercise: Exercise
    let dataStore: DataStore
    var workout: Workout
    
    // backing values
    private var _reps: MutableProperty<Int?>
    private var _sets: MutableProperty<Int?>

    // properties that are 'bind-able'
    var repsInput: MutableProperty<String>
    var setsInput: MutableProperty<String>
    var notesInput: MutableProperty<String>
    
    // used for proper display of values
    var repsDisplayProducer: SignalProducer<String, NoError> {
        get {
            return repsInput
                .producer
                .scan("") { (prev, next) in Int(next) == nil && next != "" ? prev : next }
        }
    }
    
    var setsDisplayProducer: SignalProducer<String, NoError> {
        get {
            return setsInput
                .producer
                .scan("") { (prev, next) in Int(next) == nil && next != "" ? prev : next }
        }
    }
    
    var isValidationErrorProducer: SignalProducer<ExerciseSetFormError, NoError> {
        get {
            return combineLatest(_reps.producer, _sets.producer)
                .map { (reps, sets) in

                    if reps == nil || reps == 0  {
                        return ExerciseSetFormError.InvalidRep("Reps must be a number greater than 0")
                    } else if sets == nil || sets == 0 {
                        return ExerciseSetFormError.InvalidSet("Sets must be a number greater than 0")
                    } else {
                        return ExerciseSetFormError.None
                    }
                }
                .skipRepeats(==)
        }
    }
    
    init(exercise: Exercise, workout: Workout, dataStore: DataStore) {
        
        self.exercise = exercise
        self.dataStore = dataStore
        self.workout = workout
        
        _reps = MutableProperty(nil)
        _sets = MutableProperty(nil)
        
        // these will be the default values
        repsInput = MutableProperty(String(10))
        setsInput = MutableProperty(String(4))
        notesInput = MutableProperty("")
        
        _reps <~ repsInput.producer.map { Int($0) }
        _sets <~ setsInput.producer.map { Int($0) }
    }
    
    func addExerciseSetGroup() -> SignalProducer<Workout, NSError>  {
        return dataStore
            .addExerciseSetGroup(repetitions: _reps.value!, sets: _sets.value!, exercise: exercise, notes: notesInput.value, toWorkout: workout)
    }
}
