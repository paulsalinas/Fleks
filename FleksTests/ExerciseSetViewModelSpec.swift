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
                viewModel = ExerciseSetViewModel()
            }
            
            it("should initially be valid") {
                expect(viewModel.isValid.value).to(equal(true))
            }
            
            it("should be valid when reps is a valid number") {
                viewModel.reps.value = "2"
                expect(viewModel.isValid.value).to(equal(true))
            }
            
            it("should be invalid when a reps input is not a number") {
                viewModel.reps.value = "invalid input"
                expect(viewModel.isValid.value).to(equal(false))
            }
            
            it("should display a valid number for reps even with bad inputs") {
                viewModel.reps.value = "1"
                var result = [String]()
                
                viewModel.repsDisplay.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.reps.value = "1a"
                viewModel.reps.value = "1."

                expect(result).to(equal(["1", "1", "1"]))
            }

            it("should be able to clear the reps input") {
                viewModel.reps.value = "1"
                var result = [String]()
                
                viewModel.repsDisplay.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.reps.value = ""
                
                expect(result).to(equal(["1", ""]))
            }
            
            it("should display a valid number for sets even with bad inputs") {
                viewModel.sets.value = "1"
                var result = [String]()
                
                viewModel.setsDisplay.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.sets.value = "1a"
                viewModel.sets.value = "1."
                
                expect(result).to(equal(["1", "1", "1"]))
            }
            
            it("should be able to clear the sets input") {
                viewModel.sets.value = "1"
                var result = [String]()
                
                viewModel.setsDisplay.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.sets.value = ""
                
                expect(result).to(equal(["1", ""]))
            }
            
            it("should display a valid number for resistance even with bad inputs") {
                viewModel.resistance.value = "1"
                var result = [String]()
                
                viewModel.resistanceDisplay.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.resistance.value = "1a"
                viewModel.resistance.value = "1."
                viewModel.resistance.value = "1.2"
                
                expect(result).to(equal(["1", "1", "1.", "1.2"]))
            }
            
            it("should be able to clear the resistance input") {
                viewModel.sets.value = "1"
                var result = [String]()
                
                viewModel.setsDisplay.startWithNext { next in
                    result.append(next)
                }
                
                viewModel.sets.value = ""
                
                expect(result).to(equal(["1", ""]))
            }
        }
    }
}
