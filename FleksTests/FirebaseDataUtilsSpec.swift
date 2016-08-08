//
//  FirebaseDataUtils.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-07.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Result
import ReactiveCocoa
import Nimble
import Quick
import Foundation

@testable import Fleks

class FirebaseDataUtilsSpec: QuickSpec {

    override func spec() {
        describe("FirebaseDataUtils") {
            it("should convert an ExerciseSetGroup group struct to the appropriate format required by firebase") {
                let exercise = Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")])
                let exerciseSets = (1...3).map { ExerciseSet(order: $0, repetitions: 10, exercise: exercise) }
                let exerciseSetGroup =  ExerciseSetGroup(order: 1, sets: exerciseSets, notes: "notes")
                
                let expected: NSDictionary = [
                    "notes" : "notes",
                    "exerciseSets": [
                        "1": [ "repetitions": 10, "exerciseId": "1"],
                        "2": [ "repetitions": 10, "exerciseId": "1"],
                        "3": [ "repetitions": 10, "exerciseId": "1"],
                    ]
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(exerciseSetGroup)
                expect(result).to(equal(expected))
            }
            
            it("should convert an ExerciseSet struct to the appropriate format required by firebase") {
                let exerciseSet = ExerciseSet(order: 1, repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                
                let expected: NSDictionary = [ "repetitions": 10, "exerciseId": "1"]
                let result = FirebaseDataUtils.convertFirebaseData(exerciseSet)
                
                expect(result).to(equal(expected))
            }
        }
    }
}
