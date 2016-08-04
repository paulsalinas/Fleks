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

class ExerciseSetViewModel {
    
    enum ExerciseSetFormError: ErrorType {
        case InvalidSet
        case InvalidRep
        case InvalidResistance
    }
    
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
    
    var isValidProducer: SignalProducer<Bool, NoError> {
        get {
            return combineLatest(_reps.producer, _sets.producer, _resistance.producer)
                .map { (reps, sets, resistance) in
                    return reps != nil && reps != 0 &&
                        sets != nil && sets != 0 &&
                        resistance != nil && resistance != 0
                }
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
