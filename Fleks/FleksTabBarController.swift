//
//  FleksTabBarController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-06-15.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class FleksTabBarController: UITabBarController {
    
    func injectDependencies(viewModel: ExerciseViewModel) {
        let navController = viewControllers![0] as! UINavigationController
        let exerciseTableViewController = navController.topViewController as! ExerciseTableViewController
        exerciseTableViewController.injectDependency(viewModel)
    }
    
}
