//
//  Muscle.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase

struct Muscle: Equatable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension Muscle {
    struct Keys {
        static let NAME = "name"
    }
}

extension Muscle {
    init(snapshot: FIRDataSnapshot) {
        self.id = snapshot.key
        self.name = (snapshot.value as! NSDictionary)[Muscle.Keys.NAME] as! String
    }
}

func ==(lhs: Muscle, rhs: Muscle) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}