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
        self.repetitions = (snapshot.value as! NSDictionary)["repetitions"] as! Int
    }
}

func ==(lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
    return lhs.repetitions == rhs.repetitions &&
        lhs.exercise == rhs.exercise
}

struct ExerciseSetGroup: Equatable {
    var sets: [ExerciseSet]
    var notes: String

    init(sets: [ExerciseSet], notes: String) {
        self.sets = sets
        self.notes = notes
    }
    
    init (repetitions: Int, sets: Int, exercise: Exercise, notes: String) {
        self.init(
            sets: (1...sets).map { _ in ExerciseSet(repetitions: repetitions, exercise: exercise) },
            notes: notes
        )
    }
}

extension ExerciseSetGroup {
    init (snapshot: FIRDataSnapshot, exerciseSet: [ExerciseSet]) {
        self.sets = exerciseSet
        self.notes  = (snapshot.value as! NSDictionary)["notes"] as! String
    }
}

func ==(lhs: ExerciseSetGroup, rhs: ExerciseSetGroup) -> Bool {
    return lhs.sets == rhs.sets &&
        lhs.notes == rhs.notes
}