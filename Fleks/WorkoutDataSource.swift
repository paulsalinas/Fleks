//
//  WorkoutDataSource.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class WorkoutDataSource: NSObject, UITableViewDataSource {

    private let viewModel: WorkoutViewModel
    private let cellReuseIdentifier: String
    private let tableView: UITableView
    
    init(cellReuseIdentifier: String, viewModel: WorkoutViewModel, tableView: UITableView) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.viewModel = viewModel
        self.tableView = tableView
        
        super.init()
        
        self.viewModel.refreshWorkouts { _ in
            self.tableView.reloadData()
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.workouts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        let workout = viewModel.workouts[indexPath.row]
  
        cell.textLabel?.text = workout.name
        return cell
    }
}
