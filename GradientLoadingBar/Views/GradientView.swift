//
//  GradientView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 10.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

class GradientView : UIView, CAAnimationDelegate {
    private let config = (
        fadeInAnimationKey: "GradientView--fade-in",
        fadeOutAnimationKey: "GradientView--fade-out",
        progressAnimationKey: "GradientView--progress"
    )
    
    private var gradientLayer : CAGradientLayer!
    
    private var durations : Durations
    
    override init (frame : CGRect) {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: 3 * frame.size.width, height: frame.size.height)
        
        self.gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.position = CGPoint(x: -2 * frame.size.width, y: 0)
        
        self.gradientLayer.opacity = 0.0
        
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0);
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0);
        
        // Set default durations to 0
        self.durations = Durations()
        
        // Add layer to view
        super.init(frame : frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    convenience init(frame: CGRect, durations : Durations, gradientColors : GradientColors) {
        self.init(frame: frame)
        
        // Append reversed gradient to simulate infinte animation
        self.gradientLayer.colors =
            gradientColors + gradientColors.reversed() + gradientColors;
        
        self.durations = durations
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Progress animations (automatically triggered via delegates)
    
    func animationDidStart(_ anim: CAAnimation) {
        if (anim == self.gradientLayer.animation(forKey: config.fadeInAnimationKey)) {
            // Start progress animation
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = CGPoint(x: -2 * self.frame.size.width, y: 0)
            animation.toValue = CGPoint(x: 0, y: 0)
            animation.duration = durations.progress
            animation.repeatCount = Float.infinity
        
            self.gradientLayer.add(animation, forKey: config.progressAnimationKey)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim == self.gradientLayer.animation(forKey: config.fadeOutAnimationKey)) {
            // Stop progress animation
            self.gradientLayer.removeAnimation(forKey: self.config.progressAnimationKey)
        }
    }
    
    // MARK: Fade-In / Out
    
    func toggleGradientLayerVisibility(duration: TimeInterval, from: CGFloat, to: CGFloat, key: String) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = "forwards"
        animation.isRemovedOnCompletion = false
        
        self.gradientLayer.add(animation, forKey: key)
    }
    
    func show() {
        self.gradientLayer.removeAnimation(forKey: config.fadeOutAnimationKey)
        self.toggleGradientLayerVisibility(
            duration: durations.fadeIn,
            from: 0.0,
            to: 1.0,
            key: config.fadeInAnimationKey
        )
    }
    
    func hide() {
        self.gradientLayer.removeAnimation(forKey: config.fadeInAnimationKey)
        self.toggleGradientLayerVisibility(
            duration: durations.fadeOut,
            from: 1.0,
            to: 0.0,
            key: config.fadeOutAnimationKey
        )
    }
}
