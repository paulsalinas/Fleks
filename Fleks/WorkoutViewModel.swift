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
    let user: User
    
    var workouts =  [Workout]()
    
    private var userDataRef: FIRDatabaseReference {
        get {
            return store.reference().child("users/\(user.universalId)")
        }
    }
    
    private var workoutsRef: FIRDatabaseReference {
        get {
            return userDataRef.child("workouts")
        }
    }
    
    init (store: FIRDatabase, user: User) {
        self.store = store
        self.user = user
    }
    
    func createWorkout(name: String) {
        let ref = workoutsRef.childByAutoId()
        ref.setValue(["name": name])
    }
    
    func refreshWorkouts(onComplete: [Workout] -> Void) {
        workoutsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.workouts = snapshot.children.map { Workout(snapshot: $0 as! FIRDataSnapshot) }
            onComplete(self.workouts)
        })
    }
}
