//
//  ExerciseSetSpec.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-11.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Nimble
import Quick
import Foundation

@testable import Fleks

class ExerciseSetGroupSpec: QuickSpec {
    
    override func spec() {
        describe("init") {
            it("should construct an array of exerciseSets based on reps, set, and exercise") {
                let exercise = Exercise(id: "test", name: "leg press", muscles: [Muscle(id:"test", name: "chest")])
                let result = ExerciseSetGroup(repetitions: 10, sets:2, exercise: exercise, notes: "heyyy" )
                let expected = ExerciseSetGroup(
                    sets: [
                        .Simple(ExerciseSet(repetitions: 10, exercise: exercise)),
                        .Simple(ExerciseSet(repetitions: 10, exercise: exercise))
                    ],
                    notes: "heyyy"
                )
                
                expect(result).to(equal(expected))
            }
            
            it("zzz") {}
            
        }
    }
}