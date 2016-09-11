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
            ExerciseSetGroup.Keys.NOTES : exerciseSetGroup.notes,
            ExerciseSetGroup.Keys.EXERCISE_SETS : exerciseSets
        ]
    }
    
    static func convertFirebaseData(workout: Workout) -> [String: AnyObject] {
        return [
            Workout.Keys.NAME : workout.name,
            Workout.Keys.EXERCISE_SET_GROUPS :
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
            ExerciseSet.Keys.REPETITIONS : exerciseSet.repetitions,
            ExerciseSet.Keys.EXERCISE_ID : exerciseSet.exercise.id
        ]
    }
    
    static func convertFirebaseData(exercise: Exercise) -> [String: AnyObject] {
        
        return [
            Exercise.Keys.NAME : exercise.name,
            Exercise.Keys.MUSCLES : exercise.muscles.reduce([String: AnyObject](), combine: { prev, next in
                var newDict = prev
                newDict["\(next.id)"] = true
                return newDict
            })
        ]
    }
    
    static func convertFirebaseData(exerciseSetType: ExerciseSetType) -> [String: AnyObject] {
        switch (exerciseSetType) {
        case let .Simple(set):
            return convertFirebaseData(set)
        case let .Super(sets):
            var val = [String: AnyObject]()
            sets.enumerate()
                .forEach { index, set in val[String(index)] = convertFirebaseData(set) }
            return val
        }
    }
}