//
//  FleksTabBarController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-06-15.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Firebase

// right now we use the tab bar as "smart" and a "factory"
// it knows how to create the viewmodels and is used by the other controllers
// is used by the other controllers for this purpose.
// Eventually, I'll probably move the factory to it's own class
class FleksTabBarController: UITabBarController, Alertable {
    
    var dataStore: DataStore!
    
    // TODO: remove this dependency
    private var firebaseStore: FIRDatabase!
    private var user: User!
    
    var onSignOut: () -> Void =  { _ in () }

    func injectDependencies(dataStore: DataStore, onSignOut: () -> Void) {
        let navController = viewControllers![1] as! UINavigationController
        let exerciseTableViewController = navController.topViewController as! ExerciseTableViewController
        exerciseTableViewController.injectDependency(dataStore)
        
        let workoutNavController = viewControllers![0] as! UINavigationController
        let workoutController = workoutNavController.topViewController as! WorkoutTableViewController
        workoutController.injectDependency(dataStore)
        
        self.dataStore = dataStore
        self.onSignOut = { _ in
            self.dismissViewControllerAnimated(true, completion: onSignOut)
        }
    }
    
    override func viewDidLoad() {
        dataStore.isOnline.producer.startWithNext { isOnline in
            if !isOnline {
                self.alert("you're offline! you can continue to make edits but make sure to go back online to save your data. If you close your app before going back online, your new edits will be lost!")
            }
        }
    }
}
