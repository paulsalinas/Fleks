//
//  ExerciseSetGroupsViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-08.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Result
import ReactiveCocoa

// TODO: rename to EditWorkoutViewModel
class ExerciseSetGroupsViewModel {
    private let dataStore: DataStore
    private var workout: MutableProperty<Workout?>

    let workoutNameInput: MutableProperty<String?>
    
    // TODO: I think we should be able to get rid of this and rely on the 'workout' private prop
    // only used to initialize the workout struct from the dataSource
    private var workoutId: String?
    
    init(dataStore: DataStore, workoutId: String?) {
        self.workoutId = workoutId
        self.dataStore = dataStore
        self.workout = MutableProperty(nil)
        self.workoutNameInput = MutableProperty(nil)
        self.refreshSignalProducer().take(1).start()
    }
    
    func refreshSignalProducer() -> SignalProducer<Void, NSError> {
        guard let workoutId = workoutId else {
            return SignalProducer<Void, NSError>.init(value: ())
        }

        return dataStore.workoutProducer(forWorkoutId: workoutId).on(next: { next in
            self.workout.swap(next)
            self.workoutNameInput.swap(self.workout.value?.name)
        })
        .map { _ in () }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfExerciseGroupsInSection(section: Int) -> Int {
        if let workout = workout.value {
            return workout.exerciseSets.count
        } else {
            return 0
        }
    }
    
    func doesWorkoutExist() -> Bool {
        return workout.value != nil
    }
    
    func exerciseSetGroupAtIndexPath(indexPath: NSIndexPath) -> ExerciseSetGroup {
        return workout.value!.exerciseSets[indexPath.row]
    }
    
    func createWorkout(workoutName: String, firstExercise: Exercise, reps: Int, sets: Int, notes: String) -> SignalProducer<Void, NSError> {
        let newWorkout = Workout(id: "", name: workoutName, exerciseSets: [ExerciseSetGroup(repetitions: reps, sets: sets, exercise: firstExercise, notes: notes)])
        return dataStore.addWorkout(newWorkout)
            .on(next: { addedWorkout in
                self.workout.swap(addedWorkout)
                self.workoutId = addedWorkout.id
            })
            .map { _ in () }
    }
    
    func updateExerciseSetGroup(exerciseSetGroup: ExerciseSetGroup, withReps reps: Int, withSets sets: Int, withNotes notes: String) -> SignalProducer<Void, NSError> {
        if var updatedWorkout = workout.value {
            if let index = updatedWorkout.exerciseSets.indexOf(exerciseSetGroup) {
                updatedWorkout.exerciseSets[index] = ExerciseSetGroup(repetitions: reps, sets: sets, exercise: exerciseSetGroup.sets.first!.exercise, notes: notes)
                return dataStore.updateWorkout(updatedWorkout).map { _ in () }
            }
        }
        
        return SignalProducer<Void, NSError>.empty
    }
    
    func addExerciseSetGroup(withExercise exercise: Exercise, reps: Int, sets: Int, notes: String) -> SignalProducer<Void, NSError> {
        if var updatedWorkout = workout.value {
            updatedWorkout.exerciseSets.append(ExerciseSetGroup(repetitions: reps, sets: sets, exercise: exercise, notes: notes))
            return dataStore.updateWorkout(updatedWorkout).map { _ in () }
        }
        
        return SignalProducer<Void, NSError>.empty
    }
}