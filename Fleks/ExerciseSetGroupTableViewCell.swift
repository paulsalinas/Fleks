//
//  ExerciseSetGroupTableViewCell.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-09.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ExerciseSetGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var repsSetsLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    struct ViewData {
        let sets: [ExerciseSetType]
        let notes: String
        let order: Int
    }
    
    var viewData: ViewData? {
        didSet {
            let exerciseNames = viewData!.sets.reduce([String](), combine: { prev, next in
                switch (next) {
                case .Simple(let set):
                    return prev + [set.exercise.name]
                case .Super(let exerciseSets):
                    return prev + exerciseSets.map { $0.exercise.name }
                }
            })
            
            exerciseNameLabel.text = Set(exerciseNames).joinWithSeparator("/")
            repsSetsLabel.text = "Sets: \(String(viewData!.sets.count))"
            notesLabel.text = viewData!.notes
            orderLabel.text = String(viewData!.order)
        }
    }
}

extension ExerciseSetGroupTableViewCell.ViewData {
    init(exerciseSetGroup: ExerciseSetGroup, indexPath: NSIndexPath) {
        self.sets = exerciseSetGroup.sets
        self.notes = exerciseSetGroup.notes
        self.order = indexPath.row + 1
    }
}

