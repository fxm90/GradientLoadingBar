//
//  NotchGradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 06.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import UIKit

/// Type-alias for the controller to be more similar to the pod name.
public typealias NotchGradientLoadingBar = NotchGradientLoadingBarController

open class NotchGradientLoadingBarController: GradientLoadingBarController {

    // MARK: - Private properties

    private let viewModel = NotchGradientLoadingBarViewModel()

    // MARK: - Public methods

    override open func setupConstraints(superview: UIView) {
        guard let notchDevice = viewModel.notchDevice else {
            // No special masking required for devices without a notch.
            super.setupConstraints(superview: superview)
            return
        }

        // We currently only support portrait mode (without device rotation),
        // and therefore can safely use `bounds.size.width` here.
        let screenWidth = superview.bounds.size.width

        let notchConfig = NotchConfig(notchDevice: notchDevice)
        let notchBezierPath = notchBezierPath(for: screenWidth, notchConfig: notchConfig)

        let viewHeight = notchBezierPath.bounds.height + 1
        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.topAnchor.constraint(equalTo: superview.topAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: viewHeight),

            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])

        maskView(with: notchBezierPath)
    }

    // MARK: - Private methods

    // swiftlint:disable:next function_body_length
    private func notchBezierPath(for screenWidth: CGFloat, notchConfig: NotchConfig) -> UIBezierPath {
        // We always center the notch in the middle of the screen.
        //
        // Please have a look at the graphic `Assets/iphone-x-screen-demystified.svg` or the entire article at
        // https://www.paintcodeapp.com/news/iphone-x-screen-demystified for further details on the notch layout.
        //
        // In the graphic the `leftNotchPoint` lays `83pt` from the left side of the device and
        // the `rightNotchPoint` lays `83pt` from the right.
        let leftNotchPoint = (screenWidth - notchConfig.notchWidth) / 2
        let rightNotchPoint = (screenWidth + notchConfig.notchWidth) / 2

        // The center point of the large circles lays at the bottom of the small circles.
        let smallCircleDiameter: CGFloat = 2 * notchConfig.smallCircleRadius

        // Reducing the height here a little in order to match the "basic" gradient loading bar.
        let height = height - 0.5

        let bezierPath = UIBezierPath()
        bezierPath.move(to: .zero)

        // Draw line to small-circle left to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint - notchConfig.smallCircleRadius,
                             y: 0)

        // Draw the small circle left to the `leftNotchPoint`.
        // See <https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init#1965853> for the definition of the
        // angles in the default coordinate system.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - notchConfig.smallCircleRadius,
                                              y: notchConfig.smallCircleRadius),
                          radius: notchConfig.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: true)

        // Draw the large circle right to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + notchConfig.largeCircleRadius,
                                              y: smallCircleDiameter + notchConfig.largeCircleVerticalOffset),
                          radius: notchConfig.largeCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint - notchConfig.largeCircleRadius,
                             y: smallCircleDiameter + notchConfig.largeCircleRadius + notchConfig.largeCircleVerticalOffset)

        // Draw the large circle left to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - notchConfig.largeCircleRadius,
                                              y: smallCircleDiameter + notchConfig.largeCircleVerticalOffset),
                          radius: notchConfig.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: false)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + notchConfig.smallCircleRadius,
                                              y: notchConfig.smallCircleRadius),
                          radius: notchConfig.smallCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi + CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: 0)

        // And all the way back..
        //
        // For the circles on the way back we use the same center point as in the beginning but adapt the radius.
        // See also: https://twitter.com/lilykonings/status/1567317037126680576?s=46&t=Cm2Q8BsqSY_nbCrZqGE08g

        // Draw line down.
        bezierPath.addLineTo(x: screenWidth,
                             y: height)

        // Draw line to small-circle underneath and right to `rightNotchPoint`.
        bezierPath.addLineTo(x: height + rightNotchPoint + notchConfig.smallCircleRadius,
                             y: height)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + notchConfig.smallCircleRadius,
                                              y: notchConfig.smallCircleRadius),
                          radius: notchConfig.smallCircleRadius - height,
                          startAngle: CGFloat.pi + CGFloat.pi / 2,
                          endAngle: CGFloat.pi,
                          clockwise: false)

        // Draw the large circle left to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - notchConfig.largeCircleRadius,
                                              y: smallCircleDiameter + notchConfig.largeCircleVerticalOffset),
                          radius: notchConfig.largeCircleRadius + height,
                          startAngle: 0,
                          endAngle: CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to large-circle underneath and right to `leftNotchPoint`
        bezierPath.addLineTo(x: height + leftNotchPoint + notchConfig.largeCircleRadius,
                             y: height + smallCircleDiameter + notchConfig.largeCircleRadius + notchConfig.largeCircleVerticalOffset)

        // Draw the large circle right to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + notchConfig.largeCircleRadius,
                                              y: smallCircleDiameter + notchConfig.largeCircleVerticalOffset),
                          radius: notchConfig.largeCircleRadius + height,
                          startAngle: CGFloat.pi / 2,
                          endAngle: CGFloat.pi,
                          clockwise: true)

        // Draw the small circle left to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - notchConfig.smallCircleRadius,
                                              y: notchConfig.smallCircleRadius),
                          radius: notchConfig.smallCircleRadius - height,
                          startAngle: 0,
                          endAngle: -CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to the beginning of the screen.
        bezierPath.addLineTo(x: 0, y: height)
        bezierPath.close()

        bezierPath.apply(notchConfig.transform)

        return bezierPath
    }

    private func maskView(with bezierPath: UIBezierPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor

        if #available(iOS 13.0, *) {
            shapeLayer.cornerCurve = .continuous
        }

        gradientActivityIndicatorView.layer.mask = shapeLayer
    }
}

// MARK: - Supporting Types

private struct NotchConfig {
    /// The width of the iPhone notch.
    let notchWidth: CGFloat

    /// The radius of the small circle on the outside of the notch.
    let smallCircleRadius: CGFloat = 6

    /// The radius of the large circle on the inside of the notch.
    let largeCircleRadius: CGFloat

    /// Vertical offset for the center-point of the large circle:
    /// - A positive value will move the large circles downwards.
    /// - A negative offset will move them upwards.
    let largeCircleVerticalOffset: CGFloat

    /// The transform to be applied to the entire bezier path.
    let transform: CGAffineTransform
}

private extension NotchConfig {

    /// Initializes the notch specific configuration for the current safe area device.
    ///
    /// - Note: We define this in an extension to keep the memberwise initializer.
    init(notchDevice: NotchGradientLoadingBarViewModel.NotchDevice) {
        switch notchDevice {
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax:
            /// The default configuration for the iPhone X.
            /// Values are based on <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>.
            self.init(notchWidth: 209,
                      largeCircleRadius: 22.5,
                      largeCircleVerticalOffset: -4.75,
                      transform: notchDevice == .iPhoneXSMax ? .identity : CGAffineTransform(translationX: 0.33, y: 0))

        case .iPhoneXR, .iPhone11:
            self.init(notchWidth: 230,
                      largeCircleRadius: 24,
                      largeCircleVerticalOffset: -3.5,
                      transform: .identity)

        // The "iPhone 11 Pro" and "iPhone 11 Pro Max" have a smaller notch than the "iPhone 11".
        case .iPhone11Pro, .iPhone11ProMax:
            self.init(notchWidth: 209,
                      largeCircleRadius: 21,
                      largeCircleVerticalOffset: -3.5,
                      transform: notchDevice == .iPhone11ProMax ? .identity : CGAffineTransform(translationX: 0.33, y: 0))

        // The "iPhone 12 Mini" has a larger notch than the "iPhone 12".
        case .iPhone12Mini:
            self.init(notchWidth: 226,
                      largeCircleRadius: 24,
                      largeCircleVerticalOffset: -2,
                      transform: .identity)

        case .iPhone12, .iPhone12Pro, .iPhone12ProMax:
            self.init(notchWidth: 209.5,
                      largeCircleRadius: 21,
                      largeCircleVerticalOffset: -1.75,
                      transform: .identity)

        // The "iPhone 13 Mini" has a larger notch than the "iPhone 13".
        case .iPhone13Mini:
            self.init(notchWidth: 174.75,
                      largeCircleRadius: 24.5,
                      largeCircleVerticalOffset: 0.5,
                      transform: .identity)

        case .iPhone13, .iPhone13Pro, .iPhone13ProMax, .iPhone14, .iPhone14Plus:
            // The iPhone 13 specific configuration: ‟iPhone 13 notch is 20% smaller in width, but it is also a little taller in height‟.
            // Source: <https://9to5mac.com/2021/09/14/iphone-13-notch-smaller-but-bigger>.
            self.init(notchWidth: 161,
                      largeCircleRadius: 22,
                      largeCircleVerticalOffset: -1,
                      transform: .identity)
        }
    }
}

// MARK: - Helper

private extension UIBezierPath {

    // swiftlint:disable:next identifier_name
    func addLineTo(x: CGFloat, y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }
}
