//
//  NotchGradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 06.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import UIKit

/// Type-alias for the controller to match the package name.
public typealias NotchGradientLoadingBar = NotchGradientLoadingBarController

/// A gradient loading bar controller that wraps around the iPhone notch.
///
/// ## Overview
///
/// `NotchGradientLoadingBarController` is a subclass of ``GradientLoadingBarController``
/// that renders the gradient loading bar following the curved shape of the iPhone notch.
/// On devices without a notch, it falls back to the standard loading bar behavior.
///
/// ## Usage
///
/// The usage is identical to ``GradientLoadingBarController``.
/// Please have a look at its documentation for usage examples.
///
/// ## Supported Devices
///
/// The following iPhone models with notches are supported:
/// - iPhone 11, 11 Pro, 11 Pro Max
/// - iPhone 12 Mini, 12, 12 Pro, 12 Pro Max
/// - iPhone 13 Mini, 13, 13 Pro, 13 Pro Max
/// - iPhone 14, 14 Plus
///
/// - Note: iPhone 14 Pro and later models use the Dynamic Island instead of a notch and are
///   not supported by this controller.
///
/// ## Portrait Mode Only
///
/// The notch geometry is currently optimized for portrait orientation only.
/// Device rotation is not supported!
///
/// ## Thread Safety
///
/// This class is marked with `@MainActor` and must be accessed from the main thread.
///
/// - SeeAlso:
///   - ``GradientLoadingBarController`` for the base implementation without notch support.
///   - ``GradientActivityIndicatorView`` for the underlying view that renders the gradient.
@MainActor
public class NotchGradientLoadingBarController: GradientLoadingBarController {

  // MARK: - Private Properties

  /// The view model for our controller.
  private let viewModel: NotchGradientLoadingBarViewModel

  // MARK: - Instance Lifecycle

  /// Internal initializer for dependency injection.
  /// This allows snapshot testing the controller with a mocked view model.
  init(
    height: CGFloat,
    isRelativeToSafeArea: Bool,
    gradientLoadingBarViewModel: GradientLoadingBarViewModel,
    notchGradientLoadingBarViewModel viewModel: NotchGradientLoadingBarViewModel,
  ) {
    self.viewModel = viewModel

    super.init(
      height: height,
      isRelativeToSafeArea: isRelativeToSafeArea,
      gradientLoadingBarViewModel: gradientLoadingBarViewModel,
    )
  }

  /// Creates a new notch-aware gradient loading bar controller.
  ///
  /// - Parameters:
  ///   - height: The height of the gradient bar in points.
  ///   - isRelativeToSafeArea: Boolean flag whether the top layout constraint should respect the `safeAreaLayoutGuide`.
  public convenience init(
    height: CGFloat = .GradientLoadingBar.height,
    isRelativeToSafeArea: Bool = true,
  ) {
    self.init(
      height: height,
      isRelativeToSafeArea: isRelativeToSafeArea,
      gradientLoadingBarViewModel: GradientLoadingBarController.ViewModel(),
      notchGradientLoadingBarViewModel: NotchGradientLoadingBarController.ViewModel(),
    )
  }

  // MARK: - Internal Methods

  override func setupConstraints(superview: UIView) {
    guard let notchDevice = viewModel.notchDevice else {
      // No special masking required for devices without a notch.
      super.setupConstraints(superview: superview)
      return
    }

    // We currently only support portrait mode (without device rotation),
    // and therefore can safely use `bounds.size.width` here.
    let screenWidth = superview.bounds.size.width
    let notchLayout = NotchLayout(notchDevice: notchDevice)
    let notchBezierPath: UIBezierPath = .notchBezierPath(
      screenWidth: screenWidth,
      notchLayout: notchLayout,
      height: height,
    )

    let notchBezierPathSize = notchBezierPath.bounds.size
    NSLayoutConstraint.activate([
      gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      gradientActivityIndicatorView.topAnchor.constraint(equalTo: superview.topAnchor),
      gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: notchBezierPathSize.height),
    ])

    maskView(with: notchBezierPath)
  }

  // MARK: - Private Methods

  private func maskView(with bezierPath: UIBezierPath) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = bezierPath.cgPath
    shapeLayer.fillColor = UIColor.white.cgColor
    shapeLayer.cornerCurve = .continuous

    gradientActivityIndicatorView.layer.mask = shapeLayer
  }
}

// MARK: - Helper

private extension NotchLayout {
  /// Initializes the notch layout for the given notch device.
  ///
  /// For a visual explanation of the notch geometry, see the graphic at `Assets/iphone-x-screen-demystified.svg` or
  /// the article “iPhone X Screen Demystified” at <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>.
  init(notchDevice: NotchDevice) {
    // swiftlint:disable:previous function_body_length
    switch notchDevice {
    case .iPhone11:
      self.init(
        notchWidth: 230,
        smallCircleRadius: 6,
        largeCircleRadius: 24,
        largeCircleVerticalOffset: -3.5,
        transform: .identity,
      )

    case .iPhone11Pro:
      self.init(
        notchWidth: 208,
        smallCircleRadius: 6,
        largeCircleRadius: 21,
        largeCircleVerticalOffset: -3.5,
        transform:
        // At least in the Simulator, the notch doesn't seem to be perfectly centered.
        CGAffineTransform(translationX: 0.35, y: 0),
      )

    case .iPhone11ProMax:
      self.init(
        notchWidth: 209,
        smallCircleRadius: 6,
        largeCircleRadius: 21,
        largeCircleVerticalOffset: -3.5,
        transform: .identity,
      )

    case .iPhone12Mini:
      self.init(
        notchWidth: 226,
        smallCircleRadius: 6,
        largeCircleRadius: 24,
        largeCircleVerticalOffset: -2,
        transform: .identity,
      )

    case .iPhone12, .iPhone12Pro:
      self.init(
        notchWidth: 209.75,
        smallCircleRadius: 6,
        largeCircleRadius: 21,
        largeCircleVerticalOffset: -1.75,
        transform: .identity,
      )

    case .iPhone12ProMax:
      self.init(
        notchWidth: 209,
        smallCircleRadius: 6,
        largeCircleRadius: 21,
        largeCircleVerticalOffset: -1.75,
        transform: .identity,
      )

    case .iPhone13Mini:
      self.init(
        notchWidth: 174.75,
        smallCircleRadius: 6,
        largeCircleRadius: 24.5,
        largeCircleVerticalOffset: 0.5,
        transform: .identity,
      )

    case .iPhone13, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus:
      // ‟iPhone 13 notch is 20% smaller in width, but it is also a little taller in height‟.
      // Source: https://9to5mac.com/2021/09/14/iphone-13-notch-smaller-but-bigger
      self.init(
        notchWidth: 161.25,
        smallCircleRadius: 6,
        largeCircleRadius: 22,
        largeCircleVerticalOffset: -1,
        transform: .identity,
      )
    }
  }

  /// The diameter of the small circle.
  var smallCircleDiameter: CGFloat {
    2 * smallCircleRadius
  }
}

private extension UIBezierPath {
  /// Creates a Bezier path that describes the shape of the iPhone notch.
  ///
  /// - Parameters:
  ///  - screenWidth: The width of the screen, in points.
  ///  - notchLayout: The layout configuration that defines the geometry of the notch.
  ///  - height: The vertical distance by which the path extends downward.
  ///
  /// For a visual explanation of the notch geometry, see the graphic at `Assets/iphone-x-screen-demystified.svg` or
  /// the article “iPhone X Screen Demystified” at <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>.
  static func notchBezierPath(
    // swiftlint:disable:previous function_body_length
    screenWidth: CGFloat,
    notchLayout: NotchLayout,
    height: CGFloat,
  ) -> UIBezierPath {
    // We calculate the coordinates from the the top center point of the screen.
    // Doing so centers the entire notch bezier path horizontally.
    let topCenterPoint = CGPoint(
      x: screenWidth / 2,
      y: 0,
    )

    // The center point of the small circle on the left side.
    // This circle has a `6pt` radius in the referenced graphic.
    let leftSmallCircleCenterPoint = CGPoint(
      x: topCenterPoint.x - notchLayout.notchWidth / 2 - notchLayout.smallCircleRadius,
      y: notchLayout.smallCircleRadius,
    )

    // The center point of the large circle on the left side.
    // This circle has a `20pt` radius in the referenced graphic.
    let leftLargeCircleCenterPoint = CGPoint(
      x: topCenterPoint.x - notchLayout.notchWidth / 2 + notchLayout.largeCircleRadius,
      y: notchLayout.smallCircleDiameter + notchLayout.largeCircleVerticalOffset,
    )

    // The center point of the small circle on the right side.
    // This circle has a `6pt` radius in the referenced graphic.
    let rightSmallCircleCenterPoint = CGPoint(
      x: topCenterPoint.x + notchLayout.notchWidth / 2 + notchLayout.smallCircleRadius,
      y: notchLayout.smallCircleRadius,
    )

    // The center point of the large circle on the right side.
    // This circle has a `20pt` radius in the referenced graphic.
    let rightLargeCircleCenterPoint = CGPoint(
      x: topCenterPoint.x + notchLayout.notchWidth / 2 - notchLayout.largeCircleRadius,
      y: notchLayout.smallCircleDiameter + notchLayout.largeCircleVerticalOffset,
    )

    let bezierPath = UIBezierPath()
    bezierPath.move(to: .zero)

    // Draw line to the top center point of the left small circle.
    bezierPath.addLine(
      x: leftSmallCircleCenterPoint.x,
      y: 0,
    )

    // Draw the top right quarter of the of the left small circle.
    bezierPath.addArc(
      withCenter: leftSmallCircleCenterPoint,
      radius: notchLayout.smallCircleRadius,
      startAngle: Angle.top.radians,
      endAngle: Angle.right.radians,
      clockwise: true,
    )

    // Draw the bottom left quarter of the left large circle.
    bezierPath.addArc(
      withCenter: leftLargeCircleCenterPoint,
      radius: notchLayout.largeCircleRadius,
      startAngle: Angle.left.radians,
      endAngle: Angle.bottom.radians,
      clockwise: false,
    )

    // Draw line to the bottom center point of the right large circle.
    bezierPath.addLine(
      x: rightLargeCircleCenterPoint.x,
      y: rightLargeCircleCenterPoint.y + notchLayout.largeCircleRadius,
    )

    // Draw the bottom right quarter of the right large circle.
    bezierPath.addArc(
      withCenter: rightLargeCircleCenterPoint,
      radius: notchLayout.largeCircleRadius,
      startAngle: Angle.bottom.radians,
      endAngle: Angle.right.radians,
      clockwise: false,
    )

    // Draw the top left quarter of the right small circle.
    bezierPath.addArc(
      withCenter: rightSmallCircleCenterPoint,
      radius: notchLayout.smallCircleRadius,
      startAngle: Angle.left.radians,
      endAngle: Angle.top.radians,
      clockwise: true,
    )

    // Draw line to the end of the screen.
    bezierPath.addLine(x: screenWidth, y: 0)

    // On the return path, the circles reuse the original center point, but their radius must be adjusted.
    //
    // For nested circles, the outer radius is calculated as the inner radius plus the padding between them.
    // This ensures proper alignment of the borders.
    //
    // ```
    // outerRadius = innerRadius + padding
    // ```
    //
    // https://www.30secondsofcode.org/css/s/nested-border-radius/

    // Move line down by the given height.
    bezierPath.addLine(
      x: screenWidth,
      y: height,
    )

    // Draw line to the top center point of the right small circle.
    bezierPath.addLine(
      x: height + rightSmallCircleCenterPoint.x,
      y: height,
    )

    // Draw the top left quarter of the right small circle.
    bezierPath.addArc(
      withCenter: rightSmallCircleCenterPoint,
      radius: notchLayout.smallCircleRadius - height,
      startAngle: Angle.top.radians,
      endAngle: Angle.left.radians,
      clockwise: false,
    )

    // Draw the bottom right quarter of the right large circle.
    bezierPath.addArc(
      withCenter: rightLargeCircleCenterPoint,
      radius: notchLayout.largeCircleRadius + height,
      startAngle: Angle.right.radians,
      endAngle: Angle.bottom.radians,
      clockwise: true,
    )

    // Draw line to the bottom center point of the left large circle.
    bezierPath.addLine(
      x: height + leftLargeCircleCenterPoint.x,
      y: height + leftLargeCircleCenterPoint.y + notchLayout.largeCircleRadius,
    )

    // Draw the bottom left quarter of the left large circle.
    bezierPath.addArc(
      withCenter: leftLargeCircleCenterPoint,
      radius: notchLayout.largeCircleRadius + height,
      startAngle: Angle.bottom.radians,
      endAngle: Angle.left.radians,
      clockwise: true,
    )

    // Draw the top right quarter of the left small circle.
    bezierPath.addArc(
      withCenter: leftSmallCircleCenterPoint,
      radius: notchLayout.smallCircleRadius - height,
      startAngle: Angle.right.radians,
      endAngle: Angle.top.radians,
      clockwise: false,
    )

    // Draw line to the beginning of the screen.
    bezierPath.addLine(x: 0, y: height)
    bezierPath.close()

    // Some notches require a slight transform to perfectly align.
    bezierPath.apply(notchLayout.transform)
    return bezierPath
  }

  /// Adds a line to the specified `x` and `y` coordinates (syntactic sugar).
  func addLine(x: CGFloat, y: CGFloat) {
    // swiftlint:disable:previous identifier_name
    addLine(to: CGPoint(x: x, y: y))
  }
}

// MARK: - Supporting Types

/// Represents cardinal directions as angles in UIKit’s coordinate system.
///
/// This enum is intended for use with `UIBezierPath` and other UIKit/Core Graphics
/// APIs that work with radians.
///
/// ### Coordinate system notes
/// - `0` radians points to the **right** (positive X axis)
/// - Angles increase **clockwise**
/// - The Y axis points **downward**, unlike standard Cartesian math
///
/// These conventions match `UIBezierPath(addArc:radius:startAngle:endAngle:clockwise:)`.
///
/// - SeeAlso: <https://developer.apple.com/documentation/uikit/uibezierpath/init(arccenter:radius:startangle:endangle:clockwise:)>
private enum Angle {
  case right
  case bottom
  case left
  case top

  /// The angle value in radians, suitable for UIKit drawing APIs.
  var radians: CGFloat {
    switch self {
    case .right:
      0
    case .bottom:
      .pi / 2
    case .left:
      .pi
    case .top:
      .pi * (3 / 2.0)
    }
  }
}

// swiftlint:disable:this file_length
