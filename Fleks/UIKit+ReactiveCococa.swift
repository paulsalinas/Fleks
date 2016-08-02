//
//  UIKit+ReactiveCococa.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-07-27.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Result

extension UITextField {
    func keyPress() -> SignalProducer<String, NoError> {
        return self
            .rac_textSignal()
            .toSignalProducer()
            .flatMapError { _ in SignalProducer<AnyObject?, NoError>.empty }
            .map { text in
                if let text = text {
                    return String(text)
                } else {
                    return ""
                }
            }
            //.logEvents()
    }
}

extension UIStepper {
    func changeValue() -> SignalProducer<Double, NoError> {
        return self.rac_newValueChannelWithNilValue(0)
            .toSignalProducer()
            .flatMapError { _ in SignalProducer<AnyObject?, NoError>.empty }
            .map { Double($0 as! NSNumber) }
           // .logEvents()

    }
    
}
