//
//  MRPhotoBrowserNoneAnimator.swift
//  MRPhotoBrowser
//
//  Created by biz on 2020/4/6.
//  Copyright © 2020 biz. All rights reserved.
//

import UIKit

open class MRPhotoBrowserNoneAnimator: NSObject, MRPhotoBrowserAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(transitionContext.transitionWasCancelled)
    }
    
    
    open func show(browser: MRPhotoBrowser, completion: @escaping () -> Void) {
        completion()
    }
    
    open func dismiss(browser: MRPhotoBrowser, completion: @escaping () -> Void) {
        completion()
    }
}
