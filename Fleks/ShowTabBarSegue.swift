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
        destinationViewController.injectDependencies(
            ExerciseViewModel(
                store: FIRDatabase.database(),
                user: sourceViewController.user!
            )
        )
        
        super.perform()
    }
}
