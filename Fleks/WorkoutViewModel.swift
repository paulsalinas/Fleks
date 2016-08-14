//
//  WorkoutViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-18.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class WorkoutViewModel {

    private let dataStore: DataStore
    private var workouts = [Workout]()
    
    init (dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func refreshSignalProducer() -> SignalProducer<Void, NSError> {
        return dataStore.workoutsProducer()
            .on(next: { next in self.workouts = next })
            .map { _ in () }
    }
    
    func removeWorkoutAtIndexPath(indexPath: NSIndexPath) -> SignalProducer<Void, NSError> {
        let toBeRemoved = workouts.removeAtIndex(indexPath.row)
        return dataStore.deleteWorkout(toBeRemoved).map { _ in () }
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfWorkoutsInSection(section: Int) -> Int {
        return workouts.count
    }
    
    func workoutAtIndexPath(indexPath: NSIndexPath) -> Workout {
        return workouts[indexPath.row]
    }

}
