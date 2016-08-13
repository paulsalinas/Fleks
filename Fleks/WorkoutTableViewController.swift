//
//  WorkoutTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    
    enum SegueIdentifierTypes: String {
        case ShowWorkoutDetailSegue = "showWorkoutDetailSegue"
    }
    
    private var dataSource: WorkoutDataSource!
    var client: FirebaseClient!
    private var viewModel: WorkoutViewModel!
    
    var selectedWorkout: Workout?
    
    func injectDependency(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func addWorkoutButtonTouchUp(sender: AnyObject) {
        performSegueWithIdentifier(SegueIdentifierTypes.ShowWorkoutDetailSegue.rawValue, sender: self)
    }
    override func viewDidLoad() {
        dataSource = WorkoutDataSource(cellReuseIdentifier: "workoutCell", viewModel: viewModel, tableView: tableView)
        tableView.dataSource = dataSource
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        viewModel.refreshWorkouts { _ in
            self.tableView.reloadData()
        }
        super.viewWillAppear(animated)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedWorkout = viewModel.workouts[indexPath.row]
        performSegueWithIdentifier(SegueIdentifierTypes.ShowWorkoutDetailSegue.rawValue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let id = SegueIdentifierTypes(rawValue: segue.identifier!) else {
            return
        }
        
        switch(id) {
            case .ShowWorkoutDetailSegue:
                if let destinationController = segue.destinationViewController as? ExerciseSetGroupTableViewController {
                    let tabBarVC = tabBarController as! FleksTabBarController
                    destinationController.injectDependency(tabBarVC.dataStore, workout: selectedWorkout)
                }
        }
    }
}
