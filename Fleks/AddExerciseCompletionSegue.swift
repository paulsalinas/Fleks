//
//  AddExerciseCompletionSegue.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-05-02.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class AddExerciseCompletionSegue: UIStoryboardSegue {
    
    var selectedMuscles: [Muscle] {
        return addExerciseViewController.selectedMuscles
    }
    
    var exerciseNameText: String {
        return addExerciseViewController.exerciseNameTextField.text!
    }
    
    private var addExerciseViewController: AddExerciseViewController {
        return sourceViewController as! AddExerciseViewController
    }
}
