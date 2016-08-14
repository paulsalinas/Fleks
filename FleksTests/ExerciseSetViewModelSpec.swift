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
            let repsErrorMsg = "Reps must be greater than 0"
            let setsErrorMsg = "Sets must be greater than 0"
            
            beforeEach {
                viewModel = ExerciseSetViewModel(
                    dataStore: FakeDataStore()
                )
            }
            
            it("should initially be valid") {
                var result = [InvalidInputError]()
                viewModel.isValidationErrorProducer.startWithNext { (repsError, setsError) in
                    result.append(repsError)
                    result.append(setsError)
                }
                
                let expected = [InvalidInputError.None, InvalidInputError.None]
                expect(result).to(equal(expected))
            }

            it("should be valid when reps is a valid number with no repeats and flip when invalid") {
                viewModel.repsInput.value = "2"
                var result = [InvalidInputError]()
                viewModel.isValidationErrorProducer.startWithNext { (repsError, setsError) in
                    result.append(repsError)
                    result.append(setsError)
                }
                
                viewModel.repsInput.value = "22"
                expect(result).to(equal([InvalidInputError.None, InvalidInputError.None]))
                
                viewModel.repsInput.value = "invalid"
                expect(result).to(equal([InvalidInputError.None, InvalidInputError.None, InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.None]))
                
            }

            it("should be invalid when a reps input is not a number with no repeats and flip when valid") {
                viewModel.repsInput.value = "invalid input"
                var result = [InvalidInputError]()
                viewModel.isValidationErrorProducer.startWithNext { (repsError, setsError) in
                    result.append(repsError)
                    result.append(setsError)
                }
                
                expect(result).to(equal([InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.None ]))
                
                viewModel.repsInput.value = "more invalid input"
                expect(result).to(equal([InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.None ]))
                
                viewModel.repsInput.value = "0"
                expect(result).to(equal([InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.None ]))
                
                viewModel.repsInput.value = "2"
                expect(result).to(equal([InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.None, InvalidInputError.None, InvalidInputError.None ]))
            }
            
            it("should be invalid when a sets input is not a number with no repeats and flip when valid") {
                viewModel.setsInput.value = "invalid input"
                var result = [InvalidInputError]()
                viewModel.isValidationErrorProducer.startWithNext { (repsError, setsError) in
                    result.append(repsError)
                    result.append(setsError)
                }
                
                expect(result).to(equal([ InvalidInputError.None, InvalidInputError.Invalid(setsErrorMsg)]))
                
                viewModel.setsInput.value = "more invalid input"
                expect(result).to(equal([ InvalidInputError.None, InvalidInputError.Invalid(setsErrorMsg)]))
                
                viewModel.setsInput.value = "0"
                expect(result).to(equal([ InvalidInputError.None, InvalidInputError.Invalid(setsErrorMsg)]))
                
                viewModel.setsInput.value = "2"
                expect(result).to(equal([InvalidInputError.None, InvalidInputError.Invalid(setsErrorMsg), InvalidInputError.None, InvalidInputError.None ]))
            }
            
            
            it("should both be an error when both sets and reps are invalid with no repeats and flip when valid") {
                viewModel.repsInput.value = "invalid input"
                viewModel.setsInput.value = "invalid input"
                var result = [InvalidInputError]()
                viewModel.isValidationErrorProducer.startWithNext { (repsError, setsError) in
                    result.append(repsError)
                    result.append(setsError)
                }
                
                expect(result).to(equal([ InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.Invalid(setsErrorMsg)]))
                
                viewModel.setsInput.value = "more invalid input"
                viewModel.repsInput.value = "more invalid input"
                expect(result).to(equal([ InvalidInputError.Invalid(repsErrorMsg), InvalidInputError.Invalid(setsErrorMsg)]))
                
                viewModel.setsInput.value = "0"
                viewModel.repsInput.value = "0"
                expect(result).to(equal([ InvalidInputError.Invalid(repsErrorMsg),  InvalidInputError.Invalid(setsErrorMsg)]))
                
                viewModel.setsInput.value = "2"
                viewModel.repsInput.value = "3"
                expect(result).to(equal([
                    .Invalid(repsErrorMsg),  .Invalid(setsErrorMsg),
                    .Invalid(repsErrorMsg), .None,
                    .None, .None
                ]))
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
            
            it("zzz"){}
        }
    }
}
