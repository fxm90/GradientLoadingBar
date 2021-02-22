//
//  ProgressLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by myslab on 2021/01/14.
//

import UIKit

/// Type-alias for the controller to match pod name.
public typealias ProgressLoadingBar = ProgressLoadingBarController

open class ProgressLoadingBarController: NotchGradientLoadingBarController {
    override open func setupConstraints(superview: UIView) {
        super.setupConstraints(superview: superview)
    }

    /// Progress display through rate - Rate range : 0 ~ 1
    public func setProgress(_ rate: CGFloat) {
        guard rate >= 0, rate <= 1 else { return }
        let width = UIScreen.main.bounds.size.width
        let progress = width - (width * rate)
        trailingConstraint?.constant = -progress
    }
}
