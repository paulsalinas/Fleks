//
//  Workout.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

struct Workout {
    var id: String
    var name: String
    var exerciseSets: [ExerciseSet]
}

extension Workout {
    init(snapshot: FIRDataSnapshot) {
        self.id = snapshot.key
        self.name = (snapshot.value as! NSDictionary)["name"] as! String
        
        // TODO: need to fill exercise sets
        self.exerciseSets = [ExerciseSet]()
    }
}

func ==(lhs: Workout, rhs: Workout) -> Bool {
    return lhs.id == rhs.id 
}