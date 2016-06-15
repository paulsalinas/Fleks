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
    
    private var muscles:[Muscle] = [Muscle]()
    var selectedMuscles: [Muscle] = [Muscle]()
    var onSelectMuscle: (muscle: Muscle) -> Void
    private let ref: FIRDatabaseReference
    private let tableView: UITableView
    
    private let cellReuseIdentifier: String
    
    init(cellReuseIdentifier: String, tableView: UITableView, onSelectMuscle: (muscle: Muscle) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.onSelectMuscle = onSelectMuscle
        self.ref = FirebaseClient.sharedInstance().ref.child("muscles")
        self.tableView = tableView
        super.init()
        
        self.ref.observeEventType(.Value, withBlock: { snapshot in
            self.muscles = snapshot.children.map { Muscle(snapshot: $0 as! FIRDataSnapshot) }
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return muscles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! SelectMuscleTableViewCell
        let muscle = muscles[indexPath.row]
        
        cell.viewData = SelectMuscleTableViewCell.ViewData(muscle: muscle, onSelectMuscle: onSelectMuscle)
        return cell
    }
}
