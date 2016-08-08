//
//  Firebase+ReactiveCocoa.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import Foundation
import Firebase
import ReactiveCocoa
import Result


extension FIRDatabaseReference {
    func signalProducerForEvent(event: FIRDataEventType) -> SignalProducer<FIRDataSnapshot, NSError> {
        return SignalProducer { observer, disposable in
            let handle = self.observeEventType(event,
                withBlock: { snapshot in
                    observer.sendNext(snapshot)
                },
                withCancelBlock: { err in
                    observer.sendFailed(err)
                }
            )
            disposable += { self.removeObserverWithHandle(handle) }
        }
    }
    
    func signalProducerForSingleEvent(event: FIRDataEventType) -> SignalProducer<FIRDataSnapshot, NSError> {
        return SignalProducer { observer, _ in
            self.observeSingleEventOfType(event, withBlock: { snapshot in
                observer.sendNext(snapshot)
                observer.sendCompleted()
            })
        }
    }
}