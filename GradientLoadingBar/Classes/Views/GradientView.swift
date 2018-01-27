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

    /// Animation-Keys for each animation
    enum AnimationKeys: String {
        case fadeIn
        case fadeOut
        case progress
    }

    /// `CALayer` holding the gradient.
    let gradientLayer = CAGradientLayer()

    /// Configuration with durations for each animation.
    let animationDurations: Durations

    /// Colors used for the gradient.
    let gradientColorList: [UIColor]

    // MARK: - Initializers

    /// Initializes a new gradient view (holding the `CALayer` used for the gradient)
    ///
    /// Parameters:
    ///  - animationDurations: Configuration with durations for each animation
    ///  - gradientColors:     Colors used for the gradient
    ///
    /// Returns: Instance with gradient view
    init(animationDurations: Durations, gradientColorList: [UIColor]) {
        self.animationDurations = animationDurations
        self.gradientColorList = gradientColorList

        super.init(frame: .zero)

        setupGradientLayer()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupGradientLayer() {
        gradientLayer.opacity = 0.0

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
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

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Unfortunately CGLayer is not affected by autolayout, so any change in the size of the view will not change the gradient layer.
        // That's why we'll have to update the frame here manually.

        // Three times of the width in order to apply normal, reversed and normal gradient to simulate infinte animation
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)

        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position = CGPoint(x: 0, y: 0)
    }

    // MARK: - Show / Hide

    /// Helper to toggle gradient layer visibility.
    private func updateGradientLayerVisibility(fromValue: CGFloat, toValue: CGFloat, duration: TimeInterval, animationKey: String) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self

        animation.fromValue = fromValue
        animation.toValue = toValue

        animation.duration = duration

        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false

        gradientLayer.add(animation, forKey: animationKey)
    }

    /// Fades in gradient view
    public func show() {
        // Remove possible existing fade-out animation
        gradientLayer.removeAnimation(forKey: AnimationKeys.fadeOut.rawValue)

        updateGradientLayerVisibility(fromValue: 0.0,
                                      toValue: 1.0,
                                      duration: animationDurations.fadeIn,
                                      animationKey: AnimationKeys.fadeIn.rawValue)
    }

    /// Fades out gradient view
    public func hide() {
        // Remove possible existing fade-in animation
        gradientLayer.removeAnimation(forKey: AnimationKeys.fadeIn.rawValue)

        updateGradientLayerVisibility(fromValue: 1.0,
                                      toValue: 0.0,
                                      duration: animationDurations.fadeOut,
                                      animationKey: AnimationKeys.fadeOut.rawValue)
    }
}

// MARK: - CAAnimationDelegate (used to automatically trigger progress animations)

extension GradientView: CAAnimationDelegate {

    public func animationDidStart(_ anim: CAAnimation) {
        guard anim == gradientLayer.animation(forKey: AnimationKeys.fadeIn.rawValue) else {
            // We're only interested in the "fadeIn" animation, so stop here
            return
        }

        // Start progress animation together with start of fade-in animation
        let animation = CABasicAnimation(keyPath: "position")

        animation.fromValue = CGPoint(x: -2 * bounds.size.width, y: 0)
        animation.toValue = CGPoint(x: 0, y: 0)

        animation.duration = animationDurations.progress
        animation.repeatCount = Float.infinity

        gradientLayer.add(animation, forKey: AnimationKeys.progress.rawValue)
    }

    public func animationDidStop(_ anim: CAAnimation, finished _: Bool) {
        guard anim == gradientLayer.animation(forKey: AnimationKeys.fadeOut.rawValue) else {
            // We're only interested in the "fadeOut" animation, so stop here
            return
        }

        // Stop progress animation together with finished fade-out animation
        gradientLayer.removeAnimation(forKey: AnimationKeys.progress.rawValue)
    }
}
