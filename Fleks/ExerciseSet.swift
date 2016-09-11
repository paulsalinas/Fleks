//
//  ExerciseSet.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

struct ExerciseSet: Equatable {
    var repetitions: Int
    var exercise: Exercise
}

extension ExerciseSet {
    init (snapshot: FIRDataSnapshot, exercise: Exercise) {
        self.exercise = exercise
        self.repetitions = (snapshot.value as! NSDictionary)[ExerciseSet.Keys.REPETITIONS] as! Int
    }
}

extension ExerciseSet {
    struct Keys {
        static let REPETITIONS = "repetitions"
        static let EXERCISE_ID = "exercise_id"
    }
}

func ==(lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
    return lhs.repetitions == rhs.repetitions &&
        lhs.exercise == rhs.exercise
}

// conceptually this is a grouping of sets
// this is where a person working out would take a longer than usual break
struct ExerciseSetGroup: Equatable {
    var sets: [ExerciseSetType]
    var notes: String

    init(sets: [ExerciseSetType], notes: String) {
        self.sets = sets
        self.notes = notes
    }
    
    init (repetitions: Int, sets: Int, exercise: Exercise, notes: String) {
        self.init(
            sets: (1...sets).map { _ in ExerciseSetType.Simple(ExerciseSet(repetitions: repetitions, exercise: exercise)) },
            notes: notes
        )
    }
}

extension ExerciseSetGroup {
    init (snapshot: FIRDataSnapshot, sets: [ExerciseSet]) {
        self.sets = sets.map { ExerciseSetType.Simple($0) }
        self.notes  = (snapshot.value as! NSDictionary)[ExerciseSetGroup.Keys.NOTES] as! String
    }
    
    init (snapshot: FIRDataSnapshot, setTypes: [ExerciseSetType]) {
        self.sets = setTypes.map { $0 }
        self.notes  = (snapshot.value as! NSDictionary)[ExerciseSetGroup.Keys.NOTES] as! String
    }

}

extension ExerciseSetGroup {
    struct Keys {
        static let NOTES = "notes"
        static let EXERCISE_SETS = "exercise_sets"
    }
}

func ==(lhs: ExerciseSetGroup, rhs: ExerciseSetGroup) -> Bool {
    return lhs.sets == rhs.sets &&
        lhs.notes == rhs.notes
}

// placeholder struct that will eventually replace the normal 'ExerciseSetGroup'
struct NewExerciseSetGroup: Equatable {
    var sets: [ExerciseSetType]
    var notes: String
}

func ==(lhs: NewExerciseSetGroup, rhs: NewExerciseSetGroup) -> Bool {
    return lhs.sets == rhs.sets &&
        lhs.notes == rhs.notes
}