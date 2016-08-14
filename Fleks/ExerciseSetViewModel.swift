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

enum InvalidInputError: Equatable, ErrorType {
    case Invalid(String)
    case None
}

func ==(lhs: InvalidInputError, rhs: InvalidInputError) -> Bool {
    switch (lhs, rhs) {
    case (let .Invalid(msg1), let .Invalid(msg2)):
        return msg1 == msg2
    case (.None, .None):
        return true
    default:
        return false
    }
}


class ExerciseSetViewModel {

    let dataStore: DataStore
    
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
    
    var isValidationErrorProducer: SignalProducer<(InvalidInputError, InvalidInputError), NoError> {
        get {
            return combineLatest(_reps.producer, _sets.producer)
                .map { (reps, sets) in
                    let repsError = reps == nil || reps == 0 ? InvalidInputError.Invalid("Reps must be greater than 0") : InvalidInputError.None
                    let setsError = sets == nil || sets == 0 ? InvalidInputError.Invalid("Sets must be greater than 0") : InvalidInputError.None
                    return (repsError, setsError)
                }
                .skipRepeats(==)
        }
    }
    
    convenience init (dataStore: DataStore) {
        self.init(dataStore: dataStore, reps: 12, sets: 3, notes: "Enter Notes Here")
    }
    
    init (dataStore: DataStore, reps: Int, sets: Int, notes: String) {
        self.dataStore = dataStore
        
        _reps = MutableProperty(nil)
        _sets = MutableProperty(nil)
        
        // these will be the default values
        repsInput = MutableProperty(String(reps))
        setsInput = MutableProperty(String(sets))
        notesInput = MutableProperty(notes)
        
        _reps <~ repsInput.producer.map { Int($0) }
        _sets <~ setsInput.producer.map { Int($0) }
    }
}
