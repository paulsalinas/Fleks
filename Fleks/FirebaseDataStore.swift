//
//  FirebaseDataStore.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

enum FirebaseError: ErrorType {
    case NotLoggedIn
}

class FireBaseDataStore: DataStore {
    private let db: FIRDatabase
    private let user: User
    
    init(db: FIRDatabase, user: User) {
        self.db = db
        self.user = user
    }

    func addExerciseSetGroup(repetitions repetitions: Int, sets: Int, exercise: Exercise, notes: String, toWorkout: Workout) throws -> Workout {
        throw FirebaseError.NotLoggedIn
        abort()
    }
}