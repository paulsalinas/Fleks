//
//  ExerciseSetGroupsViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-08.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation

class ExerciseSetGroupsViewModel {
    private let dataStore: DataStore
    private let workout: Workout
    
    init(dataStore: DataStore, workout: Workout) {
        self.dataStore = dataStore
        self.workout = workout
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfExerciseGroupsInSection(section: Int) -> Int {
        return workout.exerciseSets.count
    }
    
    func exerciseSetGroupAtIndexPath(indexPath: NSIndexPath) -> ExerciseSetGroup {
        return workout.exerciseSets[indexPath.row]
    }
}