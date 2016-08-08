//
//  Exercise.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import CoreData
import FirebaseDatabase 

struct Exercise: Equatable {
    var id: String
    var name: String
    var muscles: [Muscle]
}

func ==(lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.muscles == rhs.muscles
}

extension Exercise {
    init(managedExercise: NSManagedObject) {
        self.id = managedExercise.valueForKey("id") as! String
        self.name = managedExercise.valueForKey("name") as! String
        self.muscles = managedExercise.valueForKey("muscles") as! [Muscle]
    }
}

extension Exercise {
    init(snapshot: FIRDataSnapshot, muscles: [Muscle]) {
        self.id = snapshot.key
        self.name = (snapshot.value as! NSDictionary)["name"] as! String
        self.muscles = muscles
    }
}