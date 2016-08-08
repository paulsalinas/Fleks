//
//  FirebaseDataStore.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase
import ReactiveCocoa
import Result

enum FirebaseError: ErrorType {
    case NotLoggedIn
}

class FireBaseDataStore: DataStore {
    private let firebaseDB: FIRDatabase
    private let user: User
    
    private var muscles: [Muscle]
    private var exercises: [Exercise]
    
    init(firebaseDB: FIRDatabase, user: User, muscles: [Muscle]) {
        self.firebaseDB = firebaseDB
        self.user = user
        self.muscles = muscles
        self.exercises = [Exercise]()
        
        self.workoutsRef
            .signalProducerForEvent(.Value)
            .startWithNext { snapshot in
                let userExercises:[Exercise] = snapshot.children.map { snap in
                    let exerciseMuscles = self.muscles.filter { snap.childSnapshotForPath("muscles").hasChild($0.id) }
                    return Exercise(snapshot: snap as! FIRDataSnapshot, muscles: exerciseMuscles)
                }
                self.exercises = userExercises
            }
    }
    
    private var userDataRef: FIRDatabaseReference {
        get {
            return firebaseDB.reference().child("users/\(user.universalId)")
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
    
    private var musclesRef: FIRDatabaseReference {
        get {
            return firebaseDB.reference().child("muscles")
        }
    }

    func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, order: Int, toWorkout workout: Workout) throws -> SignalProducer<ExerciseSetGroup, NSError> {
        
        return SignalProducer { observer, disposable in
            
            let ref = self.workoutsRef.child(workout.id).child("exerciseSetGroups").child(String(order))
            
            let exerciseSets = (1...sets).map { ExerciseSet(order: $0, repetitions: repetitions, exercise: exercise) }
            let exerciseSetGroup =  ExerciseSetGroup(order: order, sets: exerciseSets, notes: notes)
            
            ref.setValue(FirebaseDataUtils.convertFirebaseData(exerciseSetGroup), withCompletionBlock: { error, _ in
                if let error = error {
                    observer.sendFailed(error)
                }
                observer.sendNext(exerciseSetGroup)
            })

        }
    }
}