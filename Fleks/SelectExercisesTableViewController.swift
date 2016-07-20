//
//  SelectExercisesTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class SelectExercisesTableViewController: UITableViewController {
    private var workout: Workout!
    private var viewModel: WorkoutViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.refreshExercises { _ in
            self.tableView.reloadData()
        }
    }
    
    func injectDependency(viewModel viewModel: WorkoutViewModel, workout: Workout) {
        self.viewModel = viewModel
        self.workout = workout
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.exercises.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectExerciseCell", forIndexPath: indexPath)
        let exercise = viewModel.exercises[indexPath.row]
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
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
