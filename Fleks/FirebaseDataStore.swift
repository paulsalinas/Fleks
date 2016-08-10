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
    
    private var exercises: [Exercise]
    
    init(firebaseDB: FIRDatabase, user: User) {
        self.firebaseDB = firebaseDB
        self.user = user
        self.exercises = [Exercise]()
        
        // update exercise cache and continually listen for changes
        // we might need to track this later for disposal
        self.workoutsRef
            .signalProducerForEvent(.Value)
            .startWithNext { snapshot in
                self.musclesRef
                    .signalProducerForSingleEvent(.Value)
                    .startWithNext { snapshotMuscles in
                        let muscles = snapshot.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
                        let userExercises:[Exercise] = snapshot.children.map { snap in
                            let exerciseMuscles = muscles.filter { snap.childSnapshotForPath("muscles").hasChild($0.id) }
                            return Exercise(snapshot: snap as! FIRDataSnapshot, muscles: exerciseMuscles)
                        }
                        self.exercises = userExercises
                    }
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
    
    private func exerciseSetsGroupRef(workoutId: String) -> FIRDatabaseReference {
        return self.workoutsRef.child(workoutId).child("exerciseSetGroups")
    }

    func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, toWorkout workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            var result = workout
            
            let ref = self.exerciseSetsGroupRef(workout.id).child(String(workout.exerciseSets.count))
            
            let exerciseSets = (1...sets).map { _ in ExerciseSet(repetitions: repetitions, exercise: exercise) }
            let exerciseSetGroup =  ExerciseSetGroup(sets: exerciseSets, notes: notes)
            
            result.exerciseSets.append(exerciseSetGroup)
            ref.setValue(FirebaseDataUtils.convertFirebaseData(exerciseSetGroup), withCompletionBlock: { error, _ in
                if let error = error {
                    observer.sendFailed(error)
                }
                
                observer.sendNext(result)
                observer.sendCompleted()
            })
        }
    }
    
    func exerciseSetGroupsProducer(forWorkout workout: Workout) -> SignalProducer<[ExerciseSetGroup], NSError> {
        return exerciseSetsGroupRef(workout.id).signalProducerForEvent(.Value)
            .map { mainSnapshot in
                mainSnapshot.children.map { rootSnapshot in
                     ExerciseSetGroup(
                        snapshot: rootSnapshot as! FIRDataSnapshot,
                        exerciseSet: (rootSnapshot as! FIRDataSnapshot).children.map { snapshot in
                            let exerciseId =  ((snapshot as! FIRDataSnapshot).value as! NSDictionary)["exerciseId"] as! String
                            return ExerciseSet(
                                snapshot: (snapshot as! FIRDataSnapshot),
                                exercise: self.exercises.filter { $0.id == exerciseId }.first!
                            )
                        }
                    )
                }
            }
    }
}