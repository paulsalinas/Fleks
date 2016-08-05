//
//  ExerciseSetViewModelSpec.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-01.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Result
import ReactiveCocoa
import Nimble
import Quick

@testable import Fleks

class ExerciseSetViewModelSpec: QuickSpec {
    override func spec() {
        describe("ExerciseSetViewModel") {
            var viewModel: ExerciseSetViewModel!
            let repsErrorMsg = "Reps must be a number greater than 0"
            let setsErrorMsg = "Sets must be a number greater than 0"
            let resistanceErrorMsg = "Resistance must be a number greater than 0"
            
            beforeEach {
                viewModel = ExerciseSetViewModel(exercise: Exercise(id: "test", name: "test", muscles: [Muscle]()))
            }
            
            it("should initially be valid") {
                var result = [ExerciseSetFormError]()
                viewModel.isValidationErrorProducer.startWithNext { next in
                    print(next)
                    result.append(next)
                }
                expect(result).to(equal([ExerciseSetFormError.None]))
            }

            it("should be valid when reps is a valid number with no repeats and flip when invalid") {
                viewModel.repsInput.value = "2"
                var result = [ExerciseSetFormError]()
                viewModel.isValidationErrorProducer.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.repsInput.value = "22"
                expect(result).to(equal([ExerciseSetFormError.None]))
                
                viewModel.repsInput.value = "invalid"
                expect(result).to(equal([ExerciseSetFormError.None, ExerciseSetFormError.InvalidRep(repsErrorMsg)]))
                
            }
            
            it("should be invalid when a reps input is not a number with no repeats and flip when valid") {
                viewModel.repsInput.value = "invalid input"
                var result = [ExerciseSetFormError]()
                viewModel.isValidationErrorProducer.startWithNext { next in
                    result.append(next)
                }
                
                expect(result).to(equal([ExerciseSetFormError.InvalidRep(repsErrorMsg)]))
                
                viewModel.repsInput.value = "more invalid input"
                expect(result).to(equal([ExerciseSetFormError.InvalidRep(repsErrorMsg)]))
                
                viewModel.repsInput.value = "2"
                expect(result).to(equal([ ExerciseSetFormError.InvalidRep(repsErrorMsg), ExerciseSetFormError.None,]))
            }
            
            it("should be invalid when a reps input is a zero with no repeats and flip when valid") {
                viewModel.repsInput.value = "0"
                var result = [ExerciseSetFormError]()
                viewModel.isValidationErrorProducer.startWithNext { next in
                    result.append(next)
                }
                
                expect(result).to(equal([ExerciseSetFormError.InvalidRep(repsErrorMsg)]))
                
                viewModel.repsInput.value = "0"
                expect(result).to(equal([ExerciseSetFormError.InvalidRep(repsErrorMsg)]))
                
                viewModel.repsInput.value = "2"
                expect(result).to(equal([ExerciseSetFormError.InvalidRep(repsErrorMsg), ExerciseSetFormError.None]))
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
