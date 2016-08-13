//
//  ExerciseSetGroupTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-09.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Result
import ReactiveCocoa
import Foundation

class ExerciseSetGroupTableViewController: UITableViewController {
    
    enum SegueIdentifierTypes: String {
        case EditExerciseSetGroupSegue = "EditExerciseSetGroupSegue"
        case ShowSelectExerciseModally = "ShowSelectExerciseModally"
    }
    
    enum CellTypes: String {
        case Header = "exerciseSetGroupTableHeader"
        case Normal = "exerciseSetGroupCell"
    }
    
    private var viewModel: ExerciseSetGroupsViewModel!
    private var dataStore: DataStore!
    private var workoutId: String?
    private var selectedExerciseSetGroup: ExerciseSetGroup?
    
    override func viewWillAppear(animated: Bool) {
        refresh()
        super.viewWillAppear(animated)
    }
    
    func refresh() {
        // refresh the data to make sure it's up to date
        viewModel
            .refreshSignalProducer()
            .startOn(UIScheduler())
            .take(1)
            .startWithNext { _ in
                self.tableView.reloadData()
                
                // initialize the header with the form to edit the workout name
                if let cell = self.tableView.dequeueReusableCellWithIdentifier(CellTypes.Header.rawValue) as? ExerciseSetGroupHeaderTableViewCell {
                    self.tableView.tableHeaderView = cell
                    self.viewModel.workoutNameInput
                        .producer
                        .take(1)
                        .startWithNext { next in
                            if let next = next {
                                cell.workoutNameTextField!.text = next
                            }
                        }
                    
                    self.viewModel.workoutNameInput <~ cell.workoutNameTextField.keyPress().map { $0 as String? }
                }
        }
    }
    
    func injectDependency(dataStore: DataStore, workout: Workout?) {
        self.dataStore = dataStore
        self.viewModel = ExerciseSetGroupsViewModel(dataStore: dataStore, workoutId: workout?.id)
    }

    @IBAction func addButtonTouch(sender: AnyObject) {
        performSegueWithIdentifier(SegueIdentifierTypes.ShowSelectExerciseModally.rawValue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = SegueIdentifierTypes(rawValue: segue.identifier!) else {
            return
        }
        
        switch(id) {
            case .ShowSelectExerciseModally:
                let vc = (segue.destinationViewController as! UINavigationController).topViewController as! SelectExercisesTableViewController
                
                if viewModel.doesWorkoutExist() {
                    vc.injectDependency(dataStore, onSubmitUpdate: { selectedExercise, reps, sets, notes in
                        return { _ in self.viewModel.addExerciseSetGroup(withExercise: selectedExercise, reps: reps, sets: sets, notes: notes).startWithCompleted { self.refresh() }  }
                    })
                } else {
                    vc.injectDependency(dataStore, onSubmitUpdate: { selectedExercise, reps, sets, notes in
                        return { _ in
                            self.viewModel
                                .createWorkout(self.viewModel.workoutNameInput.value!, firstExercise: selectedExercise, reps: reps, sets: sets, notes: notes)
                                .startWithCompleted { self.refresh() } // the refresh needs to be synchronous - needs to follow exactly after workout is created
                        }
                    })
                }
            
            case .EditExerciseSetGroupSegue:
                if let selectedExerciseSetGroup = selectedExerciseSetGroup,
                    let vc = segue.destinationViewController as? ExerciseSetFormViewController {
                    let sets = selectedExerciseSetGroup.sets.count
                    let reps = selectedExerciseSetGroup.sets.first!.repetitions
                    vc.injectDependency(
                        dataStore,
                        reps: reps,
                        sets: sets,
                        notes: selectedExerciseSetGroup.notes, onSubmitUpdate: { reps, sets, notes in
                            return { _ in
                                self.viewModel.updateExerciseSetGroup(
                                    selectedExerciseSetGroup,
                                    withReps: reps,
                                    withSets: sets,
                                    withNotes: notes
                                ).startWithCompleted { self.refresh() }
                            }
                        }
                    )
                }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(CellTypes.Normal.rawValue, forIndexPath: indexPath) as! ExerciseSetGroupTableViewCell
        let exerciseSetGroup = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        cell.viewData = ExerciseSetGroupTableViewCell.ViewData(exerciseSetGroup: exerciseSetGroup, indexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedExerciseSetGroup = viewModel.exerciseSetGroupAtIndexPath(indexPath)
        performSegueWithIdentifier(SegueIdentifierTypes.EditExerciseSetGroupSegue.rawValue, sender: self)
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
