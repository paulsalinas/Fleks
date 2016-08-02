//
//  ExerciseSetViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import ReactiveCocoa

enum ExerciseSetFormError: ErrorType {
    case InvalidSet
    case InvalidRep
    case InvalidResistance
}

// requirements:
// 1) resistance can accept 1 decimal, no decimals, this: "1." as a valid input
// 2) reps, resistance, sets need to be non-zero
class ExerciseSetViewModel {
    
    private let _repsVal = 10
    private let _setsVal = 4
    private let _resistanceVal = 20.0
    
    private var _reps: MutableProperty<Int?>
    private var _sets: MutableProperty<Int?>
    private var _resistance: MutableProperty<Double?>
    
    var reps: MutableProperty<String>
    var sets: MutableProperty<String>
    var resistance: MutableProperty<String>
    
    var repsProducer: SignalProducer<String, ExerciseSetFormError>!
    
    var isValid: MutableProperty<Bool> = MutableProperty(true)
    
    let repsStepValue = 1
    let setsStepValue = 1
    let resistanceStepValue = 2.5
    
    init() {
        
        _reps = MutableProperty(_repsVal)
        _sets = MutableProperty(_setsVal)
        _resistance = MutableProperty(_resistanceVal)
        
        reps = MutableProperty(String(_repsVal))
        sets = MutableProperty(String(_setsVal))
        resistance = MutableProperty(String(_resistanceVal))
        
        _reps <~ reps.map { Int($0) }
        _sets <~ sets.map { Int($0) }
        _resistance <~ resistance.map { Double($0) }
        
        combineLatest(_reps.signal, _sets.signal, _resistance.signal)
            .observeNext { reps, sets, resistance in
                if reps == nil || sets == nil || resistance == nil {
                    self.isValid.value = false
                } else {
                    self.isValid.value = true
                }
            }

    }
}
