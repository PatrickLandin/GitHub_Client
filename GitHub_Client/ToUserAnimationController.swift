//
//  ToUserAnimationController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/21/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class ToUserAnimationController : NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as SearchUsersViewController
    let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
    let containerView = transitionContext.containerView()
    
    let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as NSIndexPath
    let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCell
    let cellSnapShot = cell.imageView.snapshotViewAfterScreenUpdates(false)
    cell.imageView.hidden = true
    cellSnapShot.frame = containerView.convertRect(cell.imageView.frame, fromView: cell.imageView.superview)
    
    toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
    toVC.view.alpha = 0
    toVC.userImageView.hidden = true
    
    containerView.addSubview(toVC.view)
    containerView.addSubview(cellSnapShot)
    
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    let duration = self.transitionDuration(transitionContext)
    
    // Setup done. Animation time
    
    UIView.animateWithDuration(duration, animations: { () -> Void in
      toVC.view.alpha = 1.0
      
      let frame = containerView.convertRect(toVC.userImageView.frame, fromView: toVC.view)
      cellSnapShot.frame = frame
    
      }) { (finished) -> Void in
        
    //Clean Up
        toVC.userImageView.hidden = false
        cell.imageView.hidden = false
        cellSnapShot.removeFromSuperview()
        transitionContext.completeTransition(true)
    }
  }
  
}
