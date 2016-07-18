//
//  ExerciseViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-12.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

class ExerciseViewModel {
    private let store: FIRDatabase
    let user: User
    var exercises = [Exercise]()
    var muscles = [Muscle]()
    
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
    
    private var muscleRef: FIRDatabaseReference {
        get {
            return store.reference().child("muscles")
        }
    }
    
    init (store: FIRDatabase, user: User) {
        self.store = store
        self.user = user
    }
    
    func createExercise(name: String, muscles: [Muscle]) {
        let exerciseRef = userDataRef.child("exercises").childByAutoId()
        var exercise: [String: AnyObject] = ["name": name]
        var musclesDict = [String: Bool]()
        for muscle in muscles {
            musclesDict[muscle.id] = true
        }
        exercise["muscles"] = musclesDict
        exerciseRef.setValue(exercise)
    }
    
    func exercises(onAdd onAdd: NSIndexPath -> Void) {
        exerciseRef.observeEventType(FIRDataEventType.ChildAdded, withBlock: { snap in
            self.muscleRef.observeSingleEventOfType(.Value, withBlock: { muscleSnap in
                self.muscles = muscleSnap.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
                let exercise = Exercise(snapshot: snap, muscles: self.muscles.filter { snap.childSnapshotForPath("muscles").hasChild($0.id) })
                if !self.exercises.contains(exercise) {
                    self.exercises.append(exercise)
                     onAdd(NSIndexPath(forItem: self.exercises.count - 1, inSection: 0))
                }
            })
        })
    }
    
    func refreshMuscles(onComplete: () -> Void) {
        muscleRef.observeSingleEventOfType(.Value, withBlock: { muscleSnap in
            self.muscles = muscleSnap.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
            onComplete()
        })
    }
    
    func refreshExercises(onComplete: ([Exercise]) -> Void) {
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