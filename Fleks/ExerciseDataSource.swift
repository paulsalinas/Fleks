//
//  ExerciseDataSource.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-25.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit


class ExerciseDataSource: NSObject,  UITableViewDataSource, DataManagerDelegate {
    
    
    private let cellReuseIdentifier: String
    private let exerciseDataManager: ExerciseFirebaseDataManager
    private let tableView: UITableView
    
    init(cellReuseIdentifier: String, exerciseDataManager: ExerciseFirebaseDataManager, tableView: UITableView) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.exerciseDataManager = exerciseDataManager
        self.tableView = tableView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return exerciseDataManager.exercises.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseDataManager.exercises.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        let exercise = exerciseDataManager.exercises[indexPath.row]
        let muscleString = exercise.muscles
            .map { $0.name }
            .joinWithSeparator(", ")
        
        cell.textLabel?.text = exercise.name
        cell.detailTextLabel?.text = "Muscles: \(muscleString)"
        return cell
    }
    
    
    func dataManagerWillChangeContent(dataManager: ExerciseDataManager) {
        tableView.beginUpdates()
    }
    
    func dataManagerDidChangeContent(dataManager: ExerciseDataManager) {
        tableView.endUpdates()
    }
    
    func dataManager(dataManager: ExerciseDataManager, didInsertRowAtIndexPath indexPath: NSIndexPath) {
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func dataManager(dataManager: ExerciseDataManager, didDeleteRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}
