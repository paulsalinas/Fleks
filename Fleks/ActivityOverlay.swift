//
//  ActivityOverlay.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-08-14.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

struct ActivityOverlay {
    
    let overlayView: UIView
    let activityIndicator: UIActivityIndicatorView
    
    init (alpha: CGFloat, activityIndicatorColor: UIColor, overlayColor: UIColor) {
        overlayView = UIView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.color = activityIndicatorColor
        overlayView.alpha = alpha
        overlayView.backgroundColor = overlayColor
        overlayView.addSubview(activityIndicator)
    }
    
    
    func overlay(viewToOverlay: UIView) {
        overlayView.frame = viewToOverlay.bounds
        activityIndicator.center = CGPointMake(overlayView.frame.size.width / 2, (overlayView.frame.size.height / 2))
        viewToOverlay.addSubview(overlayView)
    }
    
    func removeOverlay() {
        overlayView.removeFromSuperview()
    }
}


protocol ActivityOverlayable: AnyObject {
    var activityOverlay: ActivityOverlay? {
        get
        set
    }

}

extension ActivityOverlayable where Self: UIViewController {
    func startOverlay() {
        self.activityOverlay = ActivityOverlay(alpha: 0.3, activityIndicatorColor: UIColor.lightGrayColor(), overlayColor: UIColor.whiteColor())
        self.activityOverlay!.overlay(self.view)
    }
    
    func stopOverlay() {
        if let activityOverlay = self.activityOverlay {
            activityOverlay.removeOverlay()
        }
    }
}
