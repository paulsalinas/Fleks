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
        describe("Input validation") {
            var viewModel: ExerciseSetViewModel!
            
            beforeEach {
                viewModel = ExerciseSetViewModel()
            }
            
            it("initially valid") {
                expect(viewModel.isValid.value).to(equal(true))
            }
            
            it("invalid when a reps input is not a number") {
                viewModel.sets.value = "invalid input"
                expect(viewModel.isValid.value).to(equal(false))
            }
        }
    }
}
