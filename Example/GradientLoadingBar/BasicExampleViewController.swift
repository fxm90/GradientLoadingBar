//
//  BasicExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 09/30/17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class BasicExampleViewController: UIViewController {
    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        GradientLoadingBar.shared.fadeOut()
    }

    @IBAction func showButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeIn()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeOut()
    }
}

class ProgressGradientProgressBar: GradientLoadingBar {
    // MARK: - Public properties

    /// Updates the percentage width of the `gradientActivityIndicatorView` where zero means zero width and one means full width of the current superview.
    var progress: CGFloat = 1 {
        didSet {
            guard let widthConstraint = widthConstraint else { return }

            self.widthConstraint = widthConstraint.setMultiplier(multiplier: progress)
            gradientActivityIndicatorView.layoutIfNeeded()
        }
    }

    // MARK: - Private properties

    private var widthConstraint: NSLayoutConstraint?

    // MARK: - Public methods

    override func setupConstraints(superview: UIView) {
        let superViewTopAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *), isRelativeToSafeArea {
            superViewTopAnchor = superview.safeAreaLayoutGuide.topAnchor
        } else {
            superViewTopAnchor = superview.topAnchor
        }

        let widthConstraint = gradientActivityIndicatorView.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: progress)
        self.widthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.topAnchor.constraint(equalTo: superViewTopAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: height),

            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            widthConstraint
        ])
    }
}

// MARK: - Helpers

private extension NSLayoutConstraint {
    /// Changes the multiplier constraint.
    ///
    /// - Parameter multiplier: The new multiplier.
    ///
    /// - Returns: NSLayoutConstraint with new multiplier.
    ///
    /// - Note: Based on <https://stackoverflow.com/a/33003217>
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(item: firstItem as Any,
                                               attribute: firstAttribute,
                                               relatedBy: relation,
                                               toItem: secondItem,
                                               attribute: secondAttribute,
                                               multiplier: multiplier,
                                               constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
