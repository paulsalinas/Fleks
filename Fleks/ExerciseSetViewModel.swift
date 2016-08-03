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


// requirements:
// 1) resistance can accept 1 decimal, no decimals, this: "1." as a valid input
// 2) reps, resistance, sets need to be non-zero
class ExerciseSetViewModel {
    
    enum ExerciseSetFormError: ErrorType {
        case InvalidSet
        case InvalidRep
        case InvalidResistance
    }
    
    private let _repsVal = 10
    private let _setsVal = 4
    private let _resistanceVal = 20.0
    
    private var _reps: MutableProperty<Int?>
    private var _sets: MutableProperty<Int?>
    private var _resistance: MutableProperty<Double?>
    
    
    // bound to inp
    var repsInput: MutableProperty<String>
    var setsInput: MutableProperty<String>
    var resistanceInput: MutableProperty<String>
    
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
    
    let repsStepValue = 1
    let setsStepValue = 1
    let resistanceStepValue = 2.5
    
    init() {
        _reps = MutableProperty(_repsVal)
        _sets = MutableProperty(_setsVal)
        _resistance = MutableProperty(_resistanceVal)
        
        repsInput = MutableProperty(String(_repsVal))
        setsInput = MutableProperty(String(_setsVal))
        resistanceInput = MutableProperty(String(_resistanceVal))
        
        _reps <~ repsInput.signal.map { Int($0) }
        _sets <~ setsInput.signal.map { Int($0) }
        _resistance <~ resistanceInput.signal.map { Double($0) }
        
        // states where private value is invalid
        isValid <~ _reps.signal.map { $0 != nil }
        isValid <~ _sets.signal.map { $0 != nil }
        isValid <~ _resistance.signal.map { $0 != nil }
    }
}
