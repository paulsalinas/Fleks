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
    
    struct ViewData {
        let reps: Int
        let sets: Int
        let exerciseName: String
        let notes: String
    }
    
    var viewData: ViewData? {
        didSet {
            exerciseNameLabel.text = viewData!.exerciseName
            notesLabel.text = viewData!.notes
            repsSetsLabel.text = "Reps: \(viewData!.reps) Sets: \(viewData!.sets)"
        }
    }
}

extension ExerciseSetGroupTableViewCell.ViewData {
    init(exerciseSetGroup: ExerciseSetGroup) {
        let set = exerciseSetGroup.sets.first!
        self.exerciseName = set.exercise.name
        self.reps = set.repetitions
        self.sets = exerciseSetGroup.sets.count
        self.notes = exerciseSetGroup.notes
    }
}

