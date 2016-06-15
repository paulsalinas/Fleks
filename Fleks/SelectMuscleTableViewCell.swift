//
//  SelectMuscleTableViewCell.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-04-27.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class SelectMuscleTableViewCell: UITableViewCell {
    
    struct ViewData {
        var muscle: Muscle
        var onSelectMuscle: (muscle: Muscle) -> Void
    }
    
    var viewData : ViewData?  {
        didSet {
            muscleTextLabel?.text = viewData?.muscle.name
        }
    }
    
    @IBOutlet weak var muscleTextLabel: UILabel!

    @IBAction func touchUpCheckbox(sender: AnyObject) {
        viewData!.onSelectMuscle(muscle: viewData!.muscle)
    }

}


