//
//  FirebaseDataUtils.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-07.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

struct FirebaseDataUtils {
    static func convertFirebaseData(exerciseSetGroup: ExerciseSetGroup) -> [String: AnyObject] {
        var exerciseSets = [String: AnyObject]()
        exerciseSetGroup.sets.forEach { exerciseSets[String($0.order)] = convertFirebaseData($0) }
        
        return  [
            "notes" : exerciseSetGroup.notes,
            "exerciseSets" : exerciseSets
        ]
    }
    
    static func convertFirebaseData(exerciseSet: ExerciseSet) -> [String: AnyObject] {
        return  [
            "repetitions" : exerciseSet.repetitions,
            "exerciseId": exerciseSet.exercise.id
        ]
    }
}