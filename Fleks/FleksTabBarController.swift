//
//  FleksTabBarController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-06-15.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class FleksTabBarController: UITabBarController {
    var client: FirebaseClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let exerciseViewController = (self.childViewControllers[0] as! UINavigationController).topViewController as! ExerciseTableViewController
        let workoutViewController = (self.childViewControllers[1] as! UINavigationController).topViewController as! WorkoutTableViewController
        
        exerciseViewController.client = client
        workoutViewController.client = client
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
