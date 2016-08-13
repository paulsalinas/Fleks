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

enum ExerciseSetFormError: Equatable, ErrorType {
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
    
//    convenience init(exercise: Exercise, workout: Workout, dataStore: DataStore) {
//        self.init(exercise: exercise, dataStore: dataStore, reps: 10, sets: 4, notes: "enter notes")
//    }
    
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
    
//    convenience init (workout: Workout, dataStore: DataStore) {
//        let exerciseSetGroup = workout.exerciseSets[order]
//        let exerciseSet = exerciseSetGroup.sets.first!
//        self.init(exercise: exerciseSet.exercise, dataStore: dataStore, reps: exerciseSet.repetitions, sets: exerciseSetGroup.sets.count, notes: exerciseSetGroup.notes)
//    }
    
//    func updateExerciseSetGroup() -> SignalProducer<Workout, NSError>  {
//        guard let reps = _reps.value, let sets = _sets.value else {
//            
//            // TODO: create an UI understood error to send
//            return SignalProducer(error: NSError(domain: "error", code: 1, userInfo: [:]))
//        }
//        
//        var updatedWorkout = workout
//        let updatedExerciseSet = ExerciseSetGroup(repetitions: reps, sets: sets, exercise: exercise, notes: notesInput.value)
//        if let order = order.value {
//            updatedWorkout.exerciseSets[order] = updatedExerciseSet
//        } else {
//            updatedWorkout.exerciseSets.append(updatedExerciseSet)
//        }
//        
//        return dataStore
//            .updateWorkout(updatedWorkout)
//            .on(next: { workout in
//                self.workout = updatedWorkout
//                if self.order.value == nil {
//                    self.order.swap(self.workout.exerciseSets.count)
//                }
//            })
//    }
}
