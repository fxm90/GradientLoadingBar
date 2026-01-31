//
//  NotchLayout.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 18.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import Foundation

/// Layout configuration for rendering a gradient loading bar that wraps around the iPhone notch.
///
/// This struct defines the geometric parameters needed to construct a bezier path
/// that follows the curved shape of the notch on different iPhone models.
///
/// For a visual explanation of the notch geometry, see the graphic at `Assets/iphone-x-screen-demystified.svg` or
/// the article “iPhone X Screen Demystified” at <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>.
struct NotchLayout {
  /// The width of the iPhone notch.
  let notchWidth: CGFloat

  /// The radius of the small circle on the outside of the notch.
  /// - Note: In the referenced graphic above, this circle has a radius of `6pt`.
  let smallCircleRadius: CGFloat

  /// The radius of the large circle on the inside of the notch.
  /// - Note: In the referenced graphic above, this circle has a radius of `20pt`.
  let largeCircleRadius: CGFloat

  /// Vertical offset for the center-point of the large circle:
  /// - A positive value will move the large circles downwards.
  /// - A negative offset will move them upwards.
  let largeCircleVerticalOffset: CGFloat

  /// The transform to be applied to the entire bezier path.
  let transform: CGAffineTransform
}
