//
//  ExerciseSetGroupTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-09.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ExerciseSetGroupTableViewController: UITableViewController {
    
    private var viewModel: ExerciseSetGroupsViewModel!
    
    func injectDependency(viewModel: ExerciseSetGroupsViewModel) {
        self.viewModel = viewModel
    }

    @IBAction func addButtonTouch(sender: AnyObject) {
        performSegueWithIdentifier("ShowSelectExerciseSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSelectExerciseSegue" {
            let vc = segue.destinationViewController as! SelectExercisesTableViewController
            let tabBarVC = tabBarController as! FleksTabBarController
            vc.injectDependency(viewModel: tabBarVC.createWorkoutViewModel(), workout: viewModel.workout)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfExerciseGroupsInSection(section)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseSetGroupCell", forIndexPath: indexPath) as! ExerciseSetGroupTableViewCell
        let exerciseSetGroup = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        cell.viewData = ExerciseSetGroupTableViewCell.ViewData(exerciseSetGroup: exerciseSetGroup, indexPath: indexPath)
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
