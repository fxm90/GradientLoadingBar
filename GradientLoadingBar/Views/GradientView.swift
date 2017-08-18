//
//  GradientView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 10.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

final class GradientView: UIView, CAAnimationDelegate {

    private struct Constants {
        static let fadeInAnimationKey = "GradientView--fade-in"
        static let fadeOutAnimationKey = "GradientView--fade-out"
        static let progressAnimationKey = "GradientView--progress"
    }

    private let gradientLayer = CAGradientLayer()

    private let durations: Durations
    private let gradientColors: GradientColors

    // MARK: - Initializers

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

    override func layoutSubviews() {
        super.layoutSubviews()

        // Three times of the width in order to apply normal, reversed and normal gradient to simulate infinte animation
        gradientLayer.frame =
            CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)

        // Update width
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        gradientLayer.position    = CGPoint(x: 0, y: 0)
    }

    // MARK: - Progress animations (automatically triggered via delegates)

    func animationDidStart(_ anim: CAAnimation) {
        if anim == gradientLayer.animation(forKey: Constants.fadeInAnimationKey) {
            // Start progress animation
            let animation = CABasicAnimation(keyPath: "position")

            animation.fromValue = CGPoint(x: -2 * bounds.size.width, y: 0)
            animation.toValue = CGPoint(x: 0, y: 0)

            animation.duration = durations.progress
            animation.repeatCount = Float.infinity

            gradientLayer.add(animation, forKey: Constants.progressAnimationKey)
        }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim == gradientLayer.animation(forKey: Constants.fadeOutAnimationKey) {
            // Stop progress animation
            gradientLayer.removeAnimation(forKey: Constants.progressAnimationKey)
        }
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

    func show() {
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

    func hide() {
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
