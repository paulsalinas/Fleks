//
//  ModalSegue.swift
//  Fleks
//
//  Created by Paul Salinas on 2016-09-05.
//  Copyright © 2016 Paul Salinas. All rights reserved.
//

import UIKit

class ModalSegue: UIStoryboardSegue, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    override func perform() {
        destinationViewController.modalPresentationStyle = .OverFullScreen
        destinationViewController.transitioningDelegate = self
        super.perform()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) is SelectRepsViewController {
            let addView = transitionContext.viewForKey(UITransitionContextToViewKey)
            addView!.alpha = 0
            transitionContext.containerView()!.addSubview(addView!)
            UIView.animateWithDuration(0.3, animations: {
                addView!.alpha = 1.0
                }, completion: { didComplete in
                    transitionContext.completeTransition(didComplete)
            })
        } else if transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) is SelectRepsViewController {
            let addView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            UIView.animateWithDuration(0.3, animations: {
                addView!.alpha = 0.0
                }, completion: { didComplete in
                    transitionContext.completeTransition(didComplete)
            })
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
}
