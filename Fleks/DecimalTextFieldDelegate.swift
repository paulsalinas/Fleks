//
//  DecimalTextFieldDelegate.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-23.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class DecimalTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let inputText = textField.text! as NSString
        let newText = inputText.stringByReplacingCharactersInRange(range, withString: string)
        
        return Float(newText) != nil || newText == ""
    }
}
