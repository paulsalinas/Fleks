//
//  ExerciseSetType.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-29.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation


enum ExerciseSetType: Equatable {
    
    case Simple (ExerciseSet)
    
    // it's really dangerous to set the inner values directly
    // can run into cases where Super has zero or 1 number of sets
    // but its intention is to store multiple anything greater than 1
    case Super ([ExerciseSet])
    
    init(set: ExerciseSet) {
        self = .Simple(set)
    }
    
    mutating func addExerciseSet(exerciseSet: ExerciseSet) {
        switch(self) {
        case .Simple(let oldExerciseSet):
            self = .Super([oldExerciseSet] + [exerciseSet])
        case .Super(let sets):
            self = .Super(sets + [exerciseSet])
        }
    }
}

func ==(lhs: ExerciseSetType, rhs: ExerciseSetType) -> Bool {
    switch (lhs, rhs) {
        case (let .Simple(setA), let .Simple(setB)):
            return setA == setB
    case (let .Super(setGroupingA), let .Super(setGroupingB)):
        return setGroupingA == setGroupingB
    default:
        return false
    }
}
