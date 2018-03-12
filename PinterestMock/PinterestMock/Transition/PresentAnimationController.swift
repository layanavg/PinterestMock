//
//  PresentAnimationController.swift
//  PINREST
//
//  Created by Layana on 08/03/18.
//  Copyright © 2018 Experion. All rights reserved.
//

import UIKit

class PresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    private let originFrame: CGRect
    private let snapFrame: CGRect
    
    init(originFrame: CGRect, snapFrame: CGRect) {
        self.originFrame = originFrame
        self.snapFrame = snapFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let snapshot = toVC.view.resizableSnapshotView(from: snapFrame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero), let fromVCSnapShot = fromVC.view.snapshotView(afterScreenUpdates: true)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        let finalFrame = CGRect(x: 0, y: 0, width: fromVCSnapShot.frame.size.width * (snapFrame.size.width / originFrame.size.width), height: fromVCSnapShot.frame.size.height * (snapFrame.size.height / originFrame.size.height))//transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = originFrame
        snapshot.layer.cornerRadius = 6
        snapshot.layer.masksToBounds = true
        
        fromVCSnapShot.layer.cornerRadius = 6
        fromVCSnapShot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVCSnapShot)
        containerView.addSubview(snapshot)
        toVC.view.alpha = 0
        fromVC.view.isHidden = true
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/5) {
                    snapshot.frame = self.snapFrame
                    fromVCSnapShot.frame = finalFrame
                    fromVCSnapShot.alpha = 0
                    toVC.view.alpha = 1
                    snapshot.layer.cornerRadius = 0
                }
        },
            completion: { _ in
                toVC.view.isHidden = false
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVCSnapShot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

