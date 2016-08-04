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
    var repsDisplay: SignalProducer<String, NoError> {
        get {
            return repsInput
                .producer
                .scan("") { (prev, next) in Int(next) == nil && next != "" ? prev : next }
        }
    }
    
    var setsDisplay: SignalProducer<String, NoError> {
        get {
            return setsInput
                .producer
                .scan("") { (prev, next) in Int(next) == nil && next != "" ? prev : next }
        }
    }
    var resistanceDisplay: SignalProducer<String, NoError> {
        get {
            return resistanceInput
                .producer
                .scan("") { (prev, next) in Double(next) == nil && next != "" ? prev : next }
        }
    }
    
    var isValid: MutableProperty<Bool> = MutableProperty(true)
    
    init(exercise: Exercise) {
        
        self.exercise = exercise
        
        _reps = MutableProperty(_repsVal)
        _sets = MutableProperty(_setsVal)
        _resistance = MutableProperty(_resistanceVal)
        
        // these will be the default values
        repsInput = MutableProperty(String(10))
        setsInput = MutableProperty(String(4))
        resistanceInput = MutableProperty(String(20))
        
        _reps <~ repsInput.signal.map { Int($0) }
        _sets <~ setsInput.signal.map { Int($0) }
        _resistance <~ resistanceInput.signal.map { Double($0) }
        
        // states where private value is invalid
        isValid <~ _reps.signal.map { $0 != nil }
        isValid <~ _sets.signal.map { $0 != nil }
        isValid <~ _resistance.signal.map { $0 != nil }
    }
}
