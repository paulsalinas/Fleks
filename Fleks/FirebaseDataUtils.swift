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
        exerciseSetGroup.sets.enumerate()
            .forEach { index, exerciseSet in  exerciseSets[String(index)] = convertFirebaseData(exerciseSet) }
        
        return  [
            "notes" : exerciseSetGroup.notes,
            "exerciseSets" : exerciseSets
        ]
    }
    
    static func convertFirebaseData(workout: Workout) -> [String: AnyObject] {
        return [
            "name" : workout.name,
            "exerciseSetGroups":
                workout.exerciseSets.enumerate()
                    .reduce([String: AnyObject]()) { prev, next in
                        let (index, exerciseSetGroup) = next
                        var new = prev
                        new[String(index)] = convertFirebaseData(exerciseSetGroup)
                        return new
                    }
        ]
    }
    
    static func convertFirebaseData(exerciseSet: ExerciseSet) -> [String: AnyObject] {
        return  [
            "repetitions" : exerciseSet.repetitions,
            "exerciseId": exerciseSet.exercise.id
        ]
    }
    
    static func convertFirebaseData(exercise: Exercise) -> [String: AnyObject] {
        
        return [
            "name": exercise.name,
            "muscles": exercise.muscles.reduce([String: AnyObject](), combine: { prev, next in
                var newDict = prev
                newDict["\(next.id)"] = true
                return newDict
            })
        ]
    }
}