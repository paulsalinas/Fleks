//
//  ExerciseDataSource.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit


class ExerciseDataSource: NSObject,  UITableViewDataSource {
    
    
    private let cellReuseIdentifier: String
    private let viewModel: ExerciseViewModel
    private let tableView: UITableView
    
    init(cellReuseIdentifier: String, viewModel: ExerciseViewModel, tableView: UITableView) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.viewModel = viewModel
        self.tableView = tableView
        
        super.init()
        
        self.viewModel.refreshExercises { _ in
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exercises.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        let exercise = viewModel.exercises[indexPath.row]
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
        return cell
    }
    
    
//    func dataManagerWillChangeContent(dataManager: ExerciseFirebaseDataManager) {
//        tableView.beginUpdates()
//    }
//    
//    func dataManagerDidChangeContent(dataManager: ExerciseFirebaseDataManager) {
//        tableView.endUpdates()
//    }
    
//    func dataManager(dataManager: ExerciseFirebaseDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }
    
//    func dataManager(dataManager: ExerciseFirebaseDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

}
