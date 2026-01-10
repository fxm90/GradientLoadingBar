//
//  GradientActivityIndicatorView+AnimateIsHidden.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 15.12.18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit

/// Convenience animation helpers for `GradientActivityIndicatorView` that
/// fade the view in and out while keeping the `isHidden` flag in sync.
///
/// - Note: These methods are implemented as a public extension on  `GradientActivityIndicatorView`
///         (rather than `UIView`) to avoid naming collisions with other frameworks.
///
/// Source: <https://gist.github.com/fxm90/723b5def31b46035cd92a641e3b184f6>
public extension GradientActivityIndicatorView {

  /// Animates the view from hidden or partially transparent to fully visible.
  ///
  /// - Parameters:
  ///   - duration: The animation duration, in seconds.
  ///   - completion: An optional closure invoked when the animation ends.
  ///                 The Boolean parameter indicates whether the animation
  ///                 completed successfully (`true`) or was interrupted (`false`).
  func fadeIn(
    duration: TimeInterval = .GradientLoadingBar.fadeInDuration,
    completion: ((Bool) -> Void)? = nil,
  ) {
    if isHidden {
      // Make sure our animation is visible.
      isHidden = false
    }

    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.beginFromCurrentState],
      animations: {
        self.alpha = 1
      },
      completion: completion,
    )
  }

  /// Animates the view from visible to fully transparent.
  ///
  /// - Note: This method:
  ///   - Sets `isHidden` to `true` only if the animation completes successfully.
  ///   - Leaves `isHidden` as `false` if the animation is interrupted,
  ///     ensuring the view remains visible during overlapping animations.
  ///
  /// - Parameters:
  ///   - duration: The animation duration, in seconds.
  ///   - completion: An optional closure invoked when the animation ends.
  ///                 The Boolean parameter indicates whether the animation
  ///                 completed successfully (`true`) or was interrupted (`false`).
  func fadeOut(
    duration: TimeInterval = .GradientLoadingBar.fadeOutDuration,
    completion: ((Bool) -> Void)? = nil,
  ) {
    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: [.beginFromCurrentState],
      animations: {
        self.alpha = 0
      },
      completion: { isFinished in
        // Update `isHidden` flag accordingly:
        //  - set to `true` in case animation was completely finished.
        //  - set to `false` in case animation was interrupted, e.g. due to starting of another animation.
        self.isHidden = isFinished

        completion?(isFinished)
      },
    )
  }

  /// Animates the view’s visibility to match the given `isHidden` value.
  ///
  /// - Parameters:
  ///   - isHidden: A Boolean value indicating whether the view should be hidden.
  ///   - duration: The animation duration, in seconds.
  ///   - completion: An optional closure invoked when the animation ends.
  ///                 The Boolean parameter indicates whether the animation
  ///                 completed successfully (`true`) or was interrupted (`false`).
  func animate(
    isHidden: Bool,
    duration: TimeInterval,
    completion: ((Bool) -> Void)? = nil,
  ) {
    if isHidden {
      fadeOut(
        duration: duration,
        completion: completion,
      )
    } else {
      fadeIn(
        duration: duration,
        completion: completion,
      )
    }
  }
}
