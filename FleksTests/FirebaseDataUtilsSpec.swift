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
            it("should convert ExerciseSetGroup to firebase format") {
                let exercise = Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")])
                let exerciseSets = (1...3).map { _ in ExerciseSetType.Simple(ExerciseSet(repetitions: 10, exercise: exercise)) }
                let exerciseSetGroup =  ExerciseSetGroup(sets: exerciseSets, notes: "notes")
                
                let expected: NSDictionary = [
                    ExerciseSetGroup.Keys.NOTES : "notes",
                    ExerciseSetGroup.Keys.EXERCISE_SETS : [
                        "0": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "1"],
                        "1": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "1"],
                        "2": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "1"],
                    ]
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(exerciseSetGroup)
                expect(result).to(equal(expected))
            }
            
            it("should convert ExerciseSet to firebase format") {
                let exerciseSet = ExerciseSet(repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                
                let expected: NSDictionary = [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "1"]
                let result = FirebaseDataUtils.convertFirebaseData(exerciseSet)
                
                expect(result).to(equal(expected))
            }
            
            it("should convert a workout to firebase format") {
                let exerciseSet1 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                let exerciseSet2 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "2", name: "leg press", muscles: [Muscle(id: "2", name: "quad")]))
                let exerciseSetGroup =  ExerciseSetGroup(sets: [.Simple(exerciseSet1), .Simple(exerciseSet2)], notes: "notes")
                
                let exerciseSet3 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "3", name: "barbell chest press", muscles: [Muscle(id: "1", name: "chest")]))
                let exerciseSet4 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "4", name: "squat", muscles: [Muscle(id: "2", name: "quad")]))
                let exerciseSetGroup2 =  ExerciseSetGroup(sets: [.Simple(exerciseSet3), .Simple(exerciseSet4)], notes: "more notes")
                
                let workout = Workout(id: "test", name: "testName", exerciseSets: [exerciseSetGroup, exerciseSetGroup2])
                
                let expected: NSDictionary = [
                    Workout.Keys.NAME : "testName",
                    Workout.Keys.EXERCISE_SET_GROUPS : [
                        "0": [
                            ExerciseSetGroup.Keys.EXERCISE_SETS : [
                                "0": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "1"],
                                "1": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "2"]
                            ],
                            "notes": "notes"
                        ],
                        "1": [
                            ExerciseSetGroup.Keys.EXERCISE_SETS : [
                                "0": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "3"],
                                "1": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "4"]
                            ],
                            ExerciseSetGroup.Keys.NOTES : "more notes"
                        ]
                    ]
                    
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(workout)
                
                expect(result).to(equal(expected))
            }
            
            it("should convert an Exercise struct to Firebase format") {
                let exercise = Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")])
           
                let expected: NSDictionary = [
                    Exercise.Keys.NAME : "chest press",
                    Exercise.Keys.MUSCLES : [
                        "1": true
                    ]
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(exercise)
                expect(result).to(equal(expected))
            }
            
            it("should convert ExerciseSetType .Super to Firebase format") {
                let exerciseSet1 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                let exerciseSet2 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "2", name: "leg press", muscles: [Muscle(id: "2", name: "quad")]))
                
                let setType = ExerciseSetType.Super([exerciseSet1, exerciseSet2])
                let expected: NSDictionary = [
                    "0": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "1"],
                    "1": [ ExerciseSet.Keys.REPETITIONS : 10, ExerciseSet.Keys.EXERCISE_ID : "2"]
                ]
                
                let result = FirebaseDataUtils.convertFirebaseData(setType)
                expect(result).to(equal(expected))
            }
            
            it("should convert ExerciseSetType .Simple to firebase format") {
                let exerciseSet1 = ExerciseSet(repetitions: 10, exercise: Exercise(id: "1", name: "chest press", muscles: [Muscle(id: "1", name: "chest")]))
                let setType = ExerciseSetType.Simple(exerciseSet1)
                
                let expected: NSDictionary = FirebaseDataUtils.convertFirebaseData(exerciseSet1)
                
                let result = FirebaseDataUtils.convertFirebaseData(setType)
                expect(result).to(equal(expected))
            }
            
            it("zzz"){}
        }
    }
}
