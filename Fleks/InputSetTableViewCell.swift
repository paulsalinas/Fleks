//
//  InputSetTableViewCell.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-02.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class InputSetTableViewCell: UITableViewCell {

    @IBOutlet weak var setStepper: UIStepper!
    @IBOutlet weak var setLabel: UILabel!
    
    var viewData: InputSetTableViewCell.ViewData? {
        didSet {
            if let label = setLabel, let stepper = setStepper {
                label.text = String(viewData!.initialValue)
                stepper.value = Double(viewData!.initialValue)
            }
        }
    }
   
    @IBAction private func onChangeStepper(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.setLabel.text = String(Int(self.setStepper.value))
        }
    }
    
    struct ViewData {
        var initialValue: Int
    }
}
