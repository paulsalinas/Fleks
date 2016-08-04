//
//  ExerciseSetViewModelSpec.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-01.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Quick
import Nimble
import Result
import ReactiveCocoa

@testable import Fleks

class ExerciseSetViewModelSpec: QuickSpec {
    override func spec() {
        describe("ExerciseSetViewModel") {
            var viewModel: ExerciseSetViewModel!
            
            beforeEach {
                viewModel = ExerciseSetViewModel(exercise: Exercise(id: "test", name: "test", muscles: [Muscle]()))
            }
            
            it("should initially be valid") {
                expect(viewModel.isValid.value).to(equal(true))
            }
            
            it("should be valid when reps is a valid number") {
                viewModel.repsInput.value = "2"
                expect(viewModel.isValid.value).to(equal(true))
            }
            
            it("should be invalid when a reps input is not a number") {
                viewModel.repsInput.value = "invalid input"
                expect(viewModel.isValid.value).to(equal(false))
            }
            
            it("should display a valid number for reps even with bad inputs") {
                viewModel.repsInput.value = "1"
                var result = [String]()
                
                viewModel.repsDisplayProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.repsInput.value = "1a"
                viewModel.repsInput.value = "1."

                expect(result).to(equal(["1", "1", "1"]))
            }

            it("should be able to clear the reps input") {
                viewModel.repsInput.value = "1"
                var result = [String]()
                
                viewModel.repsDisplayProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.repsInput.value = ""
                
                expect(result).to(equal(["1", ""]))
            }
            
            it("should display a valid number for sets even with bad inputs") {
                viewModel.setsInput.value = "1"
                var result = [String]()
                
                viewModel.setsDisplayProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.setsInput.value = "1a"
                viewModel.setsInput.value = "1."
                
                expect(result).to(equal(["1", "1", "1"]))
            }
            
            it("should be able to clear the sets input") {
                viewModel.setsInput.value = "1"
                var result = [String]()
                
                viewModel.setsDisplayProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.setsInput.value = ""
                
                expect(result).to(equal(["1", ""]))
            }
            
            it("should DisplayProducer a valid number for resistance even with bad inputs") {
                viewModel.resistanceInput.value = "1"
                var result = [String]()
                
                viewModel.resistanceDisplayProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.resistanceInput.value = "1a"
                viewModel.resistanceInput.value = "1."
                viewModel.resistanceInput.value = "1.2"
                
                expect(result).to(equal(["1", "1", "1.", "1.2"]))
            }
            
            it("should be able to clear the resistance input") {
                viewModel.resistanceInput.value = "1"
                var result = [String]()
                
                viewModel.resistanceDisplayProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.resistanceInput.value = ""
                
                expect(result).to(equal(["1", ""]))
            }
        }
    }
}
