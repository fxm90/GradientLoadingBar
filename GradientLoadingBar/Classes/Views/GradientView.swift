//
//  GradientView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 10.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

public final class GradientView: UIView {
    // MARK: - Types

    /// Animation-Keys for each animation
    static let progressAnimationKey = "GradientView--progressAnimation"

    // MARK: - Public properties

    public override var isHidden: Bool {
        didSet {
            super.isHidden = isHidden

            if isHidden {
                stopProgressAnimation()
            } else {
                startProgressAnimation()
            }
        }
    }

    // MARK: - Private properties

    /// Layer holding the gradient.
    private let gradientLayer = CAGradientLayer()

    /// Duration for the progress animation.
    private let progressAnimationDuration: TimeInterval

    /// Colors used for the gradient.
    private let gradientColorList: [UIColor]

    // MARK: - Initializers

    /// Initializes a new gradient view (holding the `CALayer` used for the gradient)
    ///
    /// Parameters:
    ///  - progressAnimationDuration: Duration for the progress animation.
    ///  - gradientColorList:         Colors used for the gradient.
    ///
    /// Returns: Instance with gradient view
    init(progressAnimationDuration: TimeInterval, gradientColorList: [UIColor]) {
        self.progressAnimationDuration = progressAnimationDuration
        self.gradientColorList = gradientColorList

        super.init(frame: .zero)

        setupGradientLayer()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Unfortunately CGLayer is not affected by autolayout, so any change in the size of the view will not change the gradient layer.
        // That's why we'll have to update the frame here manually.
        // Three times of the width in order to apply normal, reversed and normal gradient to simulate infinte animation
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        gradientLayer.position = .zero
    }

    public override func point(inside _: CGPoint, with _: UIEvent?) -> Bool {
        // Passing all touches to the next view (if any), in the view stack.
        return false
    }

    // MARK: - Private methods

    private func setupGradientLayer() {
        gradientLayer.anchorPoint = .zero

        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        // Simulate infinte animation - Therefore we'll reverse the colors and remove the first and last item
        // to prevent duplicate values at the "inner edges" destroying the infinite look.
        var reversedColorList = Array(gradientColorList.reversed())
        reversedColorList.removeFirst()
        reversedColorList.removeLast()

        let infinteColorList = gradientColorList + reversedColorList + gradientColorList
        gradientLayer.colors = infinteColorList.map({ $0.cgColor })

        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func startProgressAnimation() {
        let animation = CABasicAnimation(keyPath: "position")

        animation.fromValue = CGPoint(x: -2 * bounds.size.width, y: 0)
        animation.toValue = CGPoint.zero
        animation.duration = progressAnimationDuration
        animation.repeatCount = Float.infinity

        // Prevent stopping animation on disappearing view, and then coming back.
        animation.isRemovedOnCompletion = false

        gradientLayer.add(animation, forKey: GradientView.progressAnimationKey)
    }

    private func stopProgressAnimation() {
        gradientLayer.removeAnimation(forKey: GradientView.progressAnimationKey)
    }
}
