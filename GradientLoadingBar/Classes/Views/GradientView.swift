//
//  GradientView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 10.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

final public class GradientView: UIView, CAAnimationDelegate {

    /// Animation-Keys for each animation
    private struct Constants {
        static let fadeInAnimationKey = "GradientView--fade-in"
        static let fadeOutAnimationKey = "GradientView--fade-out"
        static let progressAnimationKey = "GradientView--progress"
    }

    /// `CALayer` holding the gradient
    private let gradientLayer = CAGradientLayer()

    /// Configuration with durations for each animation
    private let durations: Durations
    
    /// Colors used for the gradient
    private let gradientColors: GradientColors

    // MARK: - Initializers

    /// Initializes a new gradient view (holding the `CALayer` used for the gradient)
    ///
    /// Parameters:
    ///  - durations:      Configuration with durations for each animation
    ///  - gradientColors: Colors used for the gradient
    ///
    /// Returns: Instance with gradient view
    init(durations: Durations, gradientColors: GradientColors) {
        self.durations = durations
        self.gradientColors = gradientColors

        super.init(frame: .zero)

        setupGradientLayer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup "CAGradientLayer"

    private func setupGradientLayer() {
        gradientLayer.opacity = 0.0

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.0)

        // Simulate infinte animation
        var reversedColors = Array(gradientColors.reversed())
        reversedColors.removeFirst() // Remove first and last item to prevent duplicate values
        reversedColors.removeLast()  // destroying infinite animation.

        gradientLayer.colors =
            gradientColors + reversedColors + gradientColors

        // Add layer to view
        layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        // Unfortunately CGLayer is not affected by autolayout, so any change in the
        // size of the view will not change the gradient layer..

        // Three times of the width in order to apply normal, reversed and normal gradient to simulate infinte animation
        gradientLayer.frame =
            CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)

        // Update width
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position    = CGPoint(x: 0, y: 0)
    }

    // MARK: - Progress animations (automatically triggered via delegates)

    public func animationDidStart(_ anim: CAAnimation) {
        guard anim == gradientLayer.animation(forKey: Constants.fadeInAnimationKey) else { return }

        // Start progress animation
        let animation = CABasicAnimation(keyPath: "position")

        animation.fromValue = CGPoint(x: -2 * bounds.size.width, y: 0)
        animation.toValue = CGPoint(x: 0, y: 0)

        animation.duration = durations.progress
        animation.repeatCount = Float.infinity

        gradientLayer.add(animation, forKey: Constants.progressAnimationKey)
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard anim == gradientLayer.animation(forKey: Constants.fadeOutAnimationKey) else { return }

        // Stop progress animation
        gradientLayer.removeAnimation(forKey: Constants.progressAnimationKey)
    }

    // MARK: Fade-In / Out animations

    private func toggleGradientLayerVisibility(duration: TimeInterval, start: CGFloat, end: CGFloat, key: String) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self

        animation.fromValue = start
        animation.toValue = end

        animation.duration = duration

        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false

        gradientLayer.add(animation, forKey: key)
    }

    // MARK: - Public trigger methods

    public func show() {
        // Remove possible existing fade-out animation
        gradientLayer.removeAnimation(forKey: Constants.fadeOutAnimationKey)

        // Fade in gradient view
        toggleGradientLayerVisibility(
            duration: durations.fadeIn,
            start: 0.0,
            end: 1.0,
            key: Constants.fadeInAnimationKey
        )
    }

    public func hide() {
        // Remove possible existing fade-in animation
        gradientLayer.removeAnimation(forKey: Constants.fadeInAnimationKey)

        // Fade out gradient view
        toggleGradientLayerVisibility(
            duration: durations.fadeOut,
            start: 1.0,
            end: 0.0,
            key: Constants.fadeOutAnimationKey
        )
    }
}
