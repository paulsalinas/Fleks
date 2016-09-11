//
//  Workout.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

struct Workout: Equatable {
    var id: String
    var name: String
    var exerciseSets: [ExerciseSetGroup]
}

extension Workout {
    struct Keys {
        static let NAME = "name"
        static let EXERCISE_SET_GROUPS = "exercise_set_groups"
        static let ID = "id"
    }
}

extension Workout {
    init(snapshot: FIRDataSnapshot) {
        self.id = snapshot.key
        self.name = (snapshot.value as! NSDictionary)[Workout.Keys.NAME] as! String
        
        // TODO: need to fill exercise sets
        self.exerciseSets = [ExerciseSetGroup]()
    }
    
    init(snapshot: FIRDataSnapshot, exercises: [Exercise]) {
        self.id = snapshot.key
        self.name = snapshot.childSnapshotForPath(Workout.Keys.NAME).value as! String
        self.exerciseSets = snapshot.childSnapshotForPath(Workout.Keys.EXERCISE_SET_GROUPS).children
            .map { exerciseSetGroupSnapshot in
                ExerciseSetGroup(
                    snapshot: exerciseSetGroupSnapshot as! FIRDataSnapshot,
                    setTypes:
                        exerciseSetGroupSnapshot
                            .childSnapshotForPath(ExerciseSetGroup.Keys.EXERCISE_SETS)
                            .children
                            .map { exerciseSetSnapshot in
                                if  exerciseSetSnapshot.childSnapshotForPath(ExerciseSet.Keys.EXERCISE_ID).value as? String == nil, let superSets = exerciseSetSnapshot.children {
                                    return ExerciseSetType.Super(
                                        superSets.map { superSetSnap in
                                            let exercise = exercises.filter { ex in ex.id == superSetSnap.childSnapshotForPath(ExerciseSet.Keys.EXERCISE_ID).value as! String }.first!
                                            return ExerciseSet(snapshot: (superSetSnap as! FIRDataSnapshot), exercise: exercise)
                                        }
                                    )
                                } else {
                                    let exercise = exercises.filter { ex in ex.id == exerciseSetSnapshot.childSnapshotForPath(ExerciseSet.Keys.EXERCISE_ID).value as! String }.first!
                                    return ExerciseSetType.Simple(ExerciseSet(snapshot: exerciseSetSnapshot as! FIRDataSnapshot, exercise: exercise))
                                }

                            }
                )
            }
    }
}

func ==(lhs: Workout, rhs: Workout) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.exerciseSets == rhs.exerciseSets
    
}