//
//  WorkoutTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    
    private var dataSource: WorkoutDataSource!
    var client: FirebaseClient!
    private var viewModel: WorkoutViewModel!
    
    func injectDependency(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        dataSource = WorkoutDataSource(cellReuseIdentifier: "workoutCell", viewModel: viewModel, tableView: tableView)
        tableView.dataSource = dataSource
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addWorkoutSegue" {
            if let destinationController = segue.destinationViewController as? EnterWorkoutNameViewController {
                destinationController.injectDependency(viewModel)
            }
        }
    }
    
    
}
