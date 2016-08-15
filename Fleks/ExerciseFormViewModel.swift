//
//  ExerciseFormViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class ExerciseFormViewModel {
    private let dataStore: DataStore
    private var muscles = [Muscle]()
    private var selectedMuscles = [Muscle]()
    
    init (dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    var exerciseNameInput = MutableProperty("")
    
    func refreshSignalProducer() -> SignalProducer<Void, NSError> {
        return dataStore.musclesProducer()
            .on (next: { next in self.muscles = next })
            .map { _  in () }
    }
    
    func muscleSelected(muscle: Muscle) {
        if let foundIndex = self.selectedMuscles.indexOf(muscle) {
            self.selectedMuscles.removeAtIndex(foundIndex)
        } else {
            self.selectedMuscles.append(muscle)
        }
        
        print(self.getSelectedMuscles())
    }
    
    func getSelectedMuscles() -> [Muscle] {
        return selectedMuscles
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfMusclesnSection(section: Int) -> Int {
        return muscles.count
    }
    
    func muscleGroupAtIndexPath(indexPath: NSIndexPath) -> Muscle {
        return muscles[indexPath.row]
    }
    
    func isValid() -> Bool {
        return  exerciseNameInput.value != "" && selectedMuscles.count > 0
    }
}