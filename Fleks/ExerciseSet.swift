//
//  ExerciseSet.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

struct ExerciseSet: Equatable {
    var order: Int
    var repetitions: Int
    var exercise: Exercise
}

func ==(lhs: ExerciseSet, rhs: ExerciseSet) -> Bool {
    return lhs.order == rhs.order &&
        lhs.repetitions == rhs.repetitions &&
        lhs.exercise == rhs.exercise
}

struct ExerciseSetGroup: Equatable {
    var order: Int
    var sets: [ExerciseSet]
    var notes: String
}

func ==(lhs: ExerciseSetGroup, rhs: ExerciseSetGroup) -> Bool {
    return lhs.order == rhs.order &&
        lhs.sets == rhs.sets &&
        lhs.notes == rhs.notes
}