//
//  NewExerciseFormViewModel.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

class ExerciseSetFormViewModel {
    
    var numberOfSets: MutableProperty<Int> = MutableProperty(1)
    var notes: MutableProperty<String> = MutableProperty("")
    
    var refreshSignal: SignalProducer<Void, NoError> {
        get {
            return exerciseSets
                .producer
                .map { _ in return Void() }
        }
    }
    
    private var exerciseSets: MutableProperty<[ExerciseSetType]> = MutableProperty([ExerciseSetType]())
    private var sectionTitles: [String] = [String]()
    private var onComplete: (sets: [ExerciseSetType], notes:String) -> Void
    
    init (sets: [ExerciseSetType], notes: String, onComplete: (sets: [ExerciseSetType], notes:String) -> Void) {
        
        self.exerciseSets.swap(sets)
        self.notes.swap(notes)
        self.onComplete = onComplete
        self.numberOfSets.swap(sets.count)
        
        numberOfSets.signal.observeNext({ next in
            
            guard self.exerciseSets.value.count > 0 else {
                return
            }
            
            if next > self.exerciseSets.value.count {
                
                // copy last set and append it
                let copy = self.exerciseSets.value.last!
                self.exerciseSets.value.append(copy)
                
            } else if next < self.exerciseSets.value.count {
                
                // remove the end
                self.exerciseSets.value.removeLast()
            }
        })
    }
    
    convenience init () {
        self.init(sets: [ExerciseSetType](), notes: "", onComplete: {_,_ in Void() })
    }
    
    func addExercise(exercise: Exercise, withReps reps: Int) {
        exerciseSets.modify({ oldValue in
            
            // this is the first time we're adding an exercise
            // in this case, the set type would be 'simple'
            if oldValue.count == 0 {
                return (1...numberOfSets.value).map { _ in
                    ExerciseSetType(set: ExerciseSet(repetitions: reps, exercise: exercise))
                }
            }
            
            // in this case, we would be adding a second exercise to this set
            // this would make it 'super'
            return oldValue.map { setType in
                var copyToModify = setType
                copyToModify.addExerciseSet(ExerciseSet(repetitions: reps, exercise: exercise))
                return copyToModify
            }
       })
    }
    
    // section and order start at 0
    func updateExercise(reps: Int, indexPath: NSIndexPath) {
        exerciseSets.modify { value in
            var toModify = value
            switch toModify[indexPath.section] {
            case var .Simple(exerciseSet):
                exerciseSet.repetitions = reps
                toModify[indexPath.section] = .Simple(exerciseSet)
                return toModify
            case var .Super(sets):
                sets[indexPath.row].repetitions = reps
                toModify[indexPath.section] = .Super(sets)
                return toModify
            }
        }
    }
    
    func numberOfSections() -> Int {
        return exerciseSets.value.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch (exerciseSets.value[section]) {
        case .Simple:
            return 1
        case .Super(let multipleSets):
            return multipleSets.count
        }
    }
    
    func exerciseSetAtIndexPath(indexPath: NSIndexPath) -> ExerciseSet {
        switch(exerciseSets.value[indexPath.section]) {
        case .Simple(let exerciseSet):
            return exerciseSet
        case .Super(let exerciseSets):
            return exerciseSets[indexPath.row]
        }
    }
    
    func sectionTitle(section: Int) -> String {
        return ExerciseSetFormViewModel.generateLabel(section)
    }
    
    func Complete() {
        onComplete(sets: self.exerciseSets.value, notes: notes.value)
    }
}

// static pure funcs to help with some computation within the view
extension ExerciseSetFormViewModel  {
    private static func generateLabel(section: Int) -> String {
        let startingCode = 65 + section
        return "Set " + String(Character(UnicodeScalar(startingCode)))
    }
}

