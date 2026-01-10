//
//  GradientActivityIndicatorView+ViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Observation
import UIKit

extension GradientActivityIndicatorView {

  /// This view model contains all logic related to the `GradientActivityIndicatorView`
  /// and the corresponding progress animation.
  @Observable
  final class ViewModel {

    // MARK: - Internal Properties

    /// Boolean flag whether the view is currently hidden.
    var isHidden = false

    /// The state of the progress animation.
    var isAnimating: Bool {
      !isHidden
    }

    /// The bounds of the view.
    var bounds: CGRect = .zero

    /// The frame of the gradient layer.
    var gradientLayerFrame: CGRect {
      var frame = bounds
      // The width has to be three times the width of the parent bounds in order to apply the normal, reversed and
      // again normal gradient colors to simulate the infinite animation.
      frame.size.width *= 3

      return frame
    }

    /// The 'fromValue' for the progress animation.
    var animationFromValue: CGFloat {
      bounds.width * -2
    }

    /// The 'toValue' for the progress animation.
    var animationToValue: CGFloat {
      0
    }

    /// The color array used for the gradient (of type `[UIColor]`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors

    /// The color array for the gradient layer (of type `[CGColor]`).
    var gradientLayerColors: [CGColor] {
      gradientColors
        .infiniteGradientColors()
        .map(\.cgColor)
    }

    /// The duration for the progress animation.
    ///
    ///  - Note: We explicitly have to pass this value through the view-model, in order to restart the animation when
    ///          this value changes while the loading bar is visible.
    var progressAnimationDuration: TimeInterval = .GradientLoadingBar.progressDuration
  }
}

// MARK: - Helper

private extension [UIColor] {
  /// Returns a color sequence suitable for a seamless, looping gradient animation.
  ///
  /// The resulting array mirrors the colors back and forth so the gradient can animate
  /// continuously without visible seams or duplicated colors at the turning points.
  ///
  /// To avoid duplicate colors at the inner edges, the reversed sequence omits
  /// the first and last elements before being appended.
  ///
  /// Example:
  /// ```
  /// [.red, .yellow, .green]
  /// → [.red, .yellow, .green, .yellow, .red, .yellow, .green]
  ///
  /// [.red, .yellow, .green, .blue]
  /// → [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]
  /// ```
  ///
  /// - Returns: A color array that can be animated left-to-right and looped without a visible jump.
  func infiniteGradientColors() -> [UIColor] {
    guard count > 1 else { return self }

    let reversedColors = reversed()
      .dropFirst()
      .dropLast()

    return self + reversedColors + self
  }
}
