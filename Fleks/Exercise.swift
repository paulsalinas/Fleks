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
    struct Keys {
        static let ID = "id"
        static let NAME = "name"
        static let MUSCLES = "muscles"
    }
}

extension Exercise {
    init(managedExercise: NSManagedObject) {
        self.id = managedExercise.valueForKey(Exercise.Keys.ID) as! String
        self.name = managedExercise.valueForKey(Exercise.Keys.NAME) as! String
        self.muscles = managedExercise.valueForKey(Exercise.Keys.MUSCLES) as! [Muscle]
    }
}

extension Exercise {
    init(snapshot: FIRDataSnapshot, muscles: [Muscle]) {
        self.id = snapshot.key
        self.name = (snapshot.value as! NSDictionary)[Exercise.Keys.NAME] as! String
        self.muscles = muscles
    }
}