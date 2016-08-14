//
//  ShowTabBarSegue.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-16.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Firebase

class ShowTabBarSegue: UIStoryboardSegue {
    override func perform() {
        let destinationViewController = self.destinationViewController as! FleksTabBarController
        let sourceViewController = self.sourceViewController as! LoginViewController
        let store = FIRDatabase.database()
        let user = sourceViewController.user!
        let dataStore = FireBaseDataStore(firebaseDB: store, user: user)
        
        destinationViewController.injectDependencies(
            exerciseViewModel: ExerciseViewModel(
                store: store,
                user: user
            ),
            dataStore: dataStore,
            firebaseStore: store,
            user: user
        )
        
        super.perform()
    }
}
