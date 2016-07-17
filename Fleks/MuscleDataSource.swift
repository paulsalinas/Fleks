//
//  MuscleDataSource.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-27.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit
import Firebase

class MuscleDataSource: NSObject,  UITableViewDataSource {
    
    var selectedMuscles: [Muscle] = [Muscle]()
    var onSelectMuscle: (muscle: Muscle) -> Void
    private let viewModel: ExerciseViewModel
    private let tableView: UITableView
    
    private let cellReuseIdentifier: String
    
    init(cellReuseIdentifier: String, viewModel: ExerciseViewModel, tableView: UITableView, onSelectMuscle: (muscle: Muscle) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.onSelectMuscle = onSelectMuscle
        self.tableView = tableView
        self.viewModel = viewModel
        
        super.init()
        
        self.viewModel.refreshMuscles { _ in
            self.tableView.reloadData()
        }
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.muscles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! SelectMuscleTableViewCell
        let muscle = viewModel.muscles[indexPath.row]
        
        cell.viewData = SelectMuscleTableViewCell.ViewData(muscle: muscle, onSelectMuscle: onSelectMuscle)
        return cell
    }
}
