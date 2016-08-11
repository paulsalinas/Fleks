//
//  FleksTabBarController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-06-15.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Firebase

class FleksTabBarController: UITabBarController {
    
    private var dataStore: DataStore!
    
    // TODO: remove this dependency
    private var firebaseStore: FIRDatabase!
    private var user: User!

    func injectDependencies(exerciseViewModel exerciseViewModel: ExerciseViewModel, workoutViewModel: WorkoutViewModel, dataStore: DataStore, firebaseStore: FIRDatabase, user: User) {
        let navController = viewControllers![1] as! UINavigationController
        let exerciseTableViewController = navController.topViewController as! ExerciseTableViewController
        exerciseTableViewController.injectDependency(exerciseViewModel)
        
        let workoutNavController = viewControllers![0] as! UINavigationController
        let workoutController = workoutNavController.topViewController as! WorkoutTableViewController
        workoutController.injectDependency(workoutViewModel)
        
        self.dataStore = dataStore
        self.firebaseStore = firebaseStore
        self.user = user
    }
    
    func createExerciseSetViewModel(exercise: Exercise, workout: Workout) -> ExerciseSetViewModel {
        return ExerciseSetViewModel(exercise: exercise, workout: workout, dataStore: dataStore)
    }
    
    func createExerciseSetGroupViewModel(forWorkout workout: Workout) -> ExerciseSetGroupsViewModel {
        return ExerciseSetGroupsViewModel(dataStore: dataStore, workout: workout)
    }
    
    func createWorkoutViewModel() -> WorkoutViewModel {
        return WorkoutViewModel(store: self.firebaseStore, user: user)
        
    }
}
