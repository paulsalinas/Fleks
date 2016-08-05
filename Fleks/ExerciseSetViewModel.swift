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
    case InvalidResistance(String)
    case None
}

func ==(lhs: ExerciseSetFormError, rhs: ExerciseSetFormError) -> Bool {
    switch (lhs, rhs) {
    case (let .InvalidSet(msg1), let .InvalidSet(msg2)):
        return msg1 == msg2
    case (let .InvalidResistance(msg1), let .InvalidResistance(msg2)):
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
    
    private let exercise: Exercise
    
    // backing values
    private var _reps: MutableProperty<Int?>
    private var _sets: MutableProperty<Int?>
    private var _resistance: MutableProperty<Double?>

    // properties that are 'bind-able'
    var repsInput: MutableProperty<String>
    var setsInput: MutableProperty<String>
    var resistanceInput: MutableProperty<String>
    
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
    var resistanceDisplayProducer: SignalProducer<String, NoError> {
        get {
            return resistanceInput
                .producer
                .scan("") { (prev, next) in Double(next) == nil && next != "" ? prev : next }
        }
    }
    
    var isValidationErrorProducer: SignalProducer<ExerciseSetFormError, NoError> {
        get {
            return combineLatest(_reps.producer, _sets.producer, _resistance.producer)
                .map { (reps, sets, resistance) in

                    if reps == nil || reps == 0  {
                        return ExerciseSetFormError.InvalidRep("Reps must be a number greater than 0")
                    } else if sets == nil || sets == 0 {
                        return ExerciseSetFormError.InvalidSet("Sets must be a number greater than 0")
                    } else if resistance == nil || resistance == 0 {
                        return ExerciseSetFormError.InvalidResistance("Resistance must be a number greater than 0")
                    } else {
                        return ExerciseSetFormError.None
                    }
                }
                .skipRepeats(==)
        }
    }
    
    init(exercise: Exercise) {
        
        self.exercise = exercise
        
        _reps = MutableProperty(nil)
        _sets = MutableProperty(nil)
        _resistance = MutableProperty(nil)
        
        // these will be the default values
        repsInput = MutableProperty(String(10))
        setsInput = MutableProperty(String(4))
        resistanceInput = MutableProperty(String(20))
        
        _reps <~ repsInput.producer.map { Int($0) }
        _sets <~ setsInput.producer.map { Int($0) }
        _resistance <~ resistanceInput.producer.map { Double($0) }
    }
}
