//
//  WorkoutTableViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    
    private let dataSource = WorkoutDataSource(cellReuseIdentifier: "workoutCell")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = dataSource
    }
}
