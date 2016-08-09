//
//  Workout.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

struct Workout: Equatable {
    var id: String
    var name: String
    var exerciseSets: [ExerciseSetGroup]
}

extension Workout {
    init(snapshot: FIRDataSnapshot) {
        self.id = snapshot.key
        self.name = (snapshot.value as! NSDictionary)["name"] as! String
        
        // TODO: need to fill exercise sets
        self.exerciseSets = [ExerciseSetGroup]()
    }
}

func ==(lhs: Workout, rhs: Workout) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.exerciseSets == rhs.exerciseSets
    
}