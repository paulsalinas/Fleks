//
//  SelectRepsViewController.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class SelectRepsViewController: UIViewController {
    
    private var onCancel: (() -> Void)?
    private var onDone: (Int -> Void)?
    private var initialReps: Int?
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var repsStepper: UIStepper!
    
    func injectDependency(reps: Int,  onCancel: (() -> Void)?, onDone: (Int -> Void)?) {
        initialReps = reps
        
        self.onCancel = onCancel
        self.onDone = onDone
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        repsLabel.text = String(initialReps!)
        repsStepper.value = Double(initialReps!)
    }
    
    @IBAction func onChangeValue(sender: AnyObject) {
        if let stepper = sender as? UIStepper {
            repsLabel.text = String(Int(stepper.value))
        }
    }

    @IBAction func cancelTouchUp(sender: AnyObject) {
        if let onCancel = onCancel {
            onCancel()
        }
    }
    
    @IBAction func doneTouchUp(sender: AnyObject) {
        if let onDone = onDone, value = Int(repsLabel.text!) {
            onDone(value)
        }
    }
    
}
