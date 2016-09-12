//
//  NewExerciseFormViewModelSpec.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-04.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Result
import ReactiveCocoa
import Nimble
import Quick

@testable import Fleks

class NewExerciseFormViewModelSpec: QuickSpec {
    override func spec() {
        describe("ExerciseSetViewModel") {
            var viewModel: ExerciseSetFormViewModel!
            
            beforeEach {
                viewModel = ExerciseSetFormViewModel()
            }
            
            it("doesn't increase the number of sets when there's no exercise yet selected") {
                viewModel.numberOfSets.modify({ val in val + 1})
                expect(viewModel.numberOfSections()).to(equal(0))
            }
            
            it("creates the right number of sets after adding an exercise") {
                viewModel.addExercise(Exercise(id:"a", name:"great exercise", muscles:[Muscle(id: "a", name:"chest")]), withReps: 10)
                expect(viewModel.numberOfSections()).to(equal(viewModel.numberOfSets.value))
                
                viewModel.numberOfSets.modify({ val in val + 1})
                expect(viewModel.numberOfSections()).to(equal(viewModel.numberOfSets.value))
            }
            
            it("maintains the right number of sets after adding more than one exercise") {
                viewModel.addExercise(Exercise(id:"a", name:"great exercise", muscles:[Muscle(id: "a", name:"chest")]), withReps: 10)
                expect(viewModel.numberOfSections()).to(equal(viewModel.numberOfSets.value))
                
                viewModel.addExercise(Exercise(id:"b", name:"second exercise", muscles:[Muscle(id: "a", name:"chest")]), withReps: 10)
                viewModel.numberOfSets.modify({ val in val + 1})
                expect(viewModel.numberOfSections()).to(equal(viewModel.numberOfSets.value))
            }
            
            it("copies the last set when increasing the number of sets by one with an exercise chosen") {
                viewModel.numberOfSets.swap(1)
                let exercise = Exercise(id:"a", name:"great exercise", muscles:[Muscle(id: "a", name:"chest")])
                viewModel.addExercise(exercise, withReps: 10)
                
                viewModel.numberOfSets.swap(2)
                let indexPath = NSIndexPath(forRow: 1, inSection: 1)
                let exerciseSet = viewModel.exerciseSetAtIndexPath(indexPath)
                
                expect(exerciseSet).to(equal(ExerciseSet(repetitions: 10, exercise: exercise)))
                expect(viewModel.numberOfSections()).to(equal(2))
            }
            
            it("creates the proper section labels") {
                viewModel.numberOfSets.swap(1)
                let exercise = Exercise(id:"a", name:"great exercise", muscles:[Muscle(id: "a", name:"chest")])
                viewModel.addExercise(exercise, withReps: 10)
                
                viewModel.numberOfSets.swap(2)
                
                expect(viewModel.sectionTitle(0)).to(equal("Set A"))
                expect(viewModel.sectionTitle(1)).to(equal("Set B"))
            }
            
            it("sends a refresh signal after updating the reps value") {
                viewModel.numberOfSets.swap(4)
                
                let exercise = Exercise(id: "a", name: "great exercise", muscles:[Muscle(id: "a", name: "chest")])
                viewModel.addExercise(exercise, withReps: 10)
                
                let exercise2 = Exercise(id: "a", name: "second great exercise", muscles:[Muscle(id: "a", name:"chest")])
                viewModel.addExercise(exercise2, withReps: 10)
                
                var refreshCount = 0
                viewModel.refreshSignal.startWithNext { _ in
                    refreshCount = refreshCount + 1
                }
                expect(refreshCount).to(equal(1))
                
                let indexPath = NSIndexPath(forRow: 1, inSection: 1)
                viewModel.updateExercise(8, indexPath: indexPath)
                expect(viewModel.exerciseSetAtIndexPath(indexPath)).to(equal(ExerciseSet(repetitions: 8, exercise: exercise2)))
                expect(refreshCount).to(equal(2))
            }
         
            it("zzz"){}
        }
    }
}
