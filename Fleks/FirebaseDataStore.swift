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
        self.exercisesProducer().startWithNext { exercises in
            self.exercises = exercises
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
    
    func updateWorkout(workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            self.workoutsRef.child(workout.id).setValue(FirebaseDataUtils.convertFirebaseData(workout), withCompletionBlock: { error, _ in
                if let error = error {
                    observer.sendFailed(error)
                }
                
                observer.sendNext(workout)
                observer.sendCompleted()
            })
        }
    }
    
    func deleteWorkout(workout: Workout) -> SignalProducer<Workout, NSError> {
        return SignalProducer { observer, _ in
            self.workoutsRef.child(workout.id).removeValueWithCompletionBlock { err, _ in
                if let error = err {
                    observer.sendFailed(error)
                }
                observer.sendNext(workout)
                observer.sendCompleted()
            }
            
        }
    }
    
    func addWorkout(workout: Workout) -> SignalProducer<Workout, NSError> {
        var updatedWorkout = workout
        return SignalProducer { observer, _ in
            let ref = self.workoutsRef.childByAutoId()
            updatedWorkout.id = ref.key
            ref.setValue(FirebaseDataUtils.convertFirebaseData(workout), withCompletionBlock: { err, _ in
                observer.sendNext(updatedWorkout)
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
    
    func workoutProducer(forWorkoutId workoutId: String) -> SignalProducer<Workout, NSError> {
        return workoutsRef.child(workoutId).signalProducerForEvent(.Value)
            .takeWhile { snap in snap.children.allObjects.count > 0 } // ends the stream when the workout has been deleted
            .map { mainSnapshot in
                Workout(snapshot: mainSnapshot, exercises: self.exercises)
            }
    }
    
    func workoutsProducer() -> SignalProducer<[Workout], NSError> {
        return workoutsRef.signalProducerForEvent(.Value)
            .map { snap in
                snap.children.map { childSnap in
                    Workout(snapshot: childSnap as! FIRDataSnapshot, exercises: self.exercises)
                }
            }
    }
    
    func exercisesProducer() -> SignalProducer<[Exercise], NSError> {
        return exerciseRef.signalProducerForEvent(.Value).zipWith(musclesRef.signalProducerForEvent(.Value))
            .map { exerciseSnap, musclesSnap in
                let muscles = musclesSnap.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
                return exerciseSnap.children.map { ex in
                    Exercise(
                        snapshot: ex as! FIRDataSnapshot,
                        muscles: muscles.filter { muscle in ex.childSnapshotForPath("muscles").hasChild(muscle.id) }
                    )
                }
            }
    }
    
    func addExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError> {
        return SignalProducer { observer, _ in
            var newExercise = exercise
            let ref = self.exerciseRef.childByAutoId()
            newExercise.id = ref.key
            ref.setValue(FirebaseDataUtils.convertFirebaseData(newExercise), withCompletionBlock: { err, _ in
                if let error = err {
                    observer.sendFailed(error)
                }
                observer.sendNext(newExercise)
                observer.sendCompleted()
            })
        }
    }
    
    func updateExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError> {
        return SignalProducer { observer, _ in
            self.exerciseRef.child("\(exercise.id)").setValue(FirebaseDataUtils.convertFirebaseData(exercise), withCompletionBlock: { err, _ in
                if let error = err {
                    observer.sendFailed(error)
                }
                observer.sendNext(exercise)
                observer.sendCompleted()
                
            })
        }
    }
    
    func deleteExercise(exercise: Exercise) -> SignalProducer<Exercise, NSError> {
        return SignalProducer { observer, _ in
            self.exerciseRef.child("\(exercise.id)").removeValueWithCompletionBlock { err, _ in
                if let error = err {
                    observer.sendFailed(error)
                }
                observer.sendNext(exercise)
                observer.sendCompleted()
            }
        }
    }
}