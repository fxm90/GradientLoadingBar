//
//  GradientActivityIndicatorView+AnimateIsHidden.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12/15/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit

/// Helper methods to fade-in and -out the `GradientActivityIndicatorView` and update the `isHidden` flag
/// accordingly, as the progress-animation is started and stopped based on this flag.
///
/// - Note: We add these methods as public extensions on `GradientActivityIndicatorView` instead of `UIView`,
/// in order to avoid conflicts with other frameworks.
///
/// - SeeAlso: [Github Gist – UIView+AnimateIsHidden.swift](https://gist.github.com/fxm90/723b5def31b46035cd92a641e3b184f6)
public extension GradientActivityIndicatorView {
    // MARK: - Public methods

    /// Updates the view visibility.
    ///
    /// - Parameters:
    ///   - isHidden: The new view visibility.
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    func animate(isHidden: Bool, duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            fadeOut(duration: duration,
                    completion: completion)
        } else {
            fadeIn(duration: duration,
                   completion: completion)
        }
    }

    /// Fade out the current view by animating the `alpha` to zero and update the `isHidden` flag accordingly.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    func fadeOut(duration: TimeInterval = TimeInterval.GradientLoadingBar.fadeOutDuration, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: {
                           self.alpha = 0.0
                       },
                       completion: { isFinished in
                           // Update `isHidden` flag accordingly:
                           //  - set to `true` in case animation was completly finished.
                           //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
                           self.isHidden = isFinished

                           completion?(isFinished)
        })
    }

    /// Fade in the current view by setting the `isHidden` flag to `false` and animating the `alpha` to one.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, measured in seconds.
    ///   - completion: Closure to be executed when the animation sequence ends. This block has no return value and takes a single Boolean
    ///                 argument that indicates whether or not the animations actually finished before the completion handler was called.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/uikit/uiview/1622515-animatewithduration
    func fadeIn(duration: TimeInterval = TimeInterval.GradientLoadingBar.fadeInDuration, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            // Make sure our animation is visible.
            isHidden = false
        }

        UIView.animate(withDuration: duration,
                       animations: {
                           self.alpha = 1.0
                       },
                       completion: completion)
    }
}
