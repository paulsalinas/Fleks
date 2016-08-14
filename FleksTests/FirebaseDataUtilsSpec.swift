//
//  FirebaseDataUtils.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-07.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Nimble
import Quick
import Foundation

@testable import Fleks

class FirebaseDataUtilsSpec: QuickSpec {

    override func spec() {
        describe("FirebaseDataUtils") {
            it("should convert an ExerciseSetGroup group struct to the appropriate format required by firebase") {
                let exercise = Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")])
                let exerciseSets = (1...3).map { _ in ExerciseSet(repetitions: 10, exercise: exercise) }
                let exerciseSetGroup =  ExerciseSetGroup(sets: exerciseSets, notes: "notes")
                
                let expected: NSDictionary = [
                    "notes" : "notes",
                    "exerciseSets": [
                        "0": [ "repetitions": 10, "exerciseId": "1"],
                        "1": [ "repetitions": 10, "exerciseId": "1"],
                        "2": [ "repetitions": 10, "exerciseId": "1"],
                    ]
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(exerciseSetGroup)
                expect(result).to(equal(expected))
            }
            
            it("should convert an ExerciseSet struct to the appropriate format required by firebase") {
                let exerciseSet = ExerciseSet(repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                
                let expected: NSDictionary = [ "repetitions": 10, "exerciseId": "1"]
                let result = FirebaseDataUtils.convertFirebaseData(exerciseSet)
                
                expect(result).to(equal(expected))
            }
            
            it("should convert a workout struct to the appropriate format required by firebase") {
                let exerciseSet1 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                let exerciseSet2 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "2", name: "leg press", muscles: [Muscle(id: "2", name: "quad")]))
                let exerciseSetGroup =  ExerciseSetGroup(sets: [exerciseSet1, exerciseSet2], notes: "notes")
                
                let exerciseSet3 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "3", name: "barbell chest press", muscles: [Muscle(id: "1", name: "chest")]))
                let exerciseSet4 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "4", name: "squat", muscles: [Muscle(id: "2", name: "quad")]))
                let exerciseSetGroup2 =  ExerciseSetGroup(sets: [exerciseSet3, exerciseSet4], notes: "more notes")
                
                let workout = Workout(id: "test", name: "testName", exerciseSets: [exerciseSetGroup, exerciseSetGroup2])
                
                let expected: NSDictionary = [
                    "name": "testName",
                    "exerciseSetGroups": [
                        "0": [
                            "exerciseSets": [
                                "0": [ "repetitions": 10, "exerciseId": "1"],
                                "1": [ "repetitions": 10, "exerciseId": "2"]
                            ],
                            "notes": "notes"
                        ],
                        "1": [
                            "exerciseSets": [
                                "0": [ "repetitions": 10, "exerciseId": "3"],
                                "1": [ "repetitions": 10, "exerciseId": "4"]
                            ],
                            "notes": "more notes"
                        ]
                    ]
                    
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(workout)
                
                expect(result).to(equal(expected))
            }
            
            it("should convert an Exercise struct to the appropriate format required by firebase") {
                let exercise = Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")])
           
                let expected: NSDictionary = [
                    "name" : "chest press",
                    "muscles": [
                        "1": true
                    ]
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(exercise)
                expect(result).to(equal(expected))
            }
            
            it("zzz"){}
        }
    }
}
