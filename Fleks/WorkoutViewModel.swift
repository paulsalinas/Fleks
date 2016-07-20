//
//  WorkoutViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-18.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

class WorkoutViewModel {
    private let store: FIRDatabase
    private let user: User
    private var muscles: [Muscle]!
    
    var workouts =  [Workout]()
    var exercises = [Exercise]()
    
    private var userDataRef: FIRDatabaseReference {
        get {
            return store.reference().child("users/\(user.universalId)")
        }
    }
    
    private var exerciseRef: FIRDatabaseReference {
        get {
            return userDataRef.child("exercises")
        }
    }
    
    private var workoutsRef: FIRDatabaseReference {
        get {
            return userDataRef.child("workouts")
        }
    }
    
    private var muscleRef: FIRDatabaseReference {
        get {
            return store.reference().child("muscles")
        }
    }
    
    init (store: FIRDatabase, user: User) {
        self.store = store
        self.user = user
    }
    
    func createWorkout(name: String) -> Workout {
        let ref = workoutsRef.childByAutoId()
        ref.setValue(["name": name])
        return Workout(id: ref.key, name: name, exerciseSets: [ExerciseSet]())
    }
    
    func refreshWorkouts(onComplete: [Workout] -> Void) {
        workoutsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.workouts = snapshot.children.map { Workout(snapshot: $0 as! FIRDataSnapshot) }
            onComplete(self.workouts)
        })
    }
    
    func refreshExercises(onComplete: [Exercise] -> Void) {
        muscleRef.observeSingleEventOfType(.Value, withBlock: { muscleSnap in
            self.muscles = muscleSnap.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
            
            self.exerciseRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let userExercises:[Exercise] = snapshot.children.map { snap in
                    let exerciseMuscles = self.muscles.filter { snap.childSnapshotForPath("muscles").hasChild($0.id) }
                    return Exercise(snapshot: snap as! FIRDataSnapshot, muscles: exerciseMuscles)
                }
                self.exercises = userExercises
                onComplete(self.exercises)
            })
            
        })
    }

}
