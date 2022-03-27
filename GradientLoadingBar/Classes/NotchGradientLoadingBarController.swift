//
//  NotchGradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 06.11.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import UIKit

// MARK: - Types

private struct NotchConfig {
    /// The width of the iPhone notch.
    let notchWidth: CGFloat

    /// The radius of the small circle on the outside of the notch.
    let smallCircleRadius: CGFloat = 6

    /// The radius of the large circle on the inside of the notch.
    let largeCircleRadius: CGFloat

    /// Offset for the center-point of the large circle.
    ///
    /// - A positive value for the `X` property will move the large circles closer to the center of the screen. A negative offset closer to
    ///   the corners of the screen.
    ///
    /// - A positive value for the `Y` property will move the large circles downwards. A negative offset will move them upwards.
    let largeCircleOffset: CGPoint

    /// The transform to be applied to the entire bezier path.
    let transform: CGAffineTransform
}

/// Type-alias for the controller to be more similar to the pod name.
public typealias NotchGradientLoadingBar = NotchGradientLoadingBarController

open class NotchGradientLoadingBarController: GradientLoadingBarController {
    // MARK: - Private properties

    private let viewModel = NotchGradientLoadingBarViewModel()

    // MARK: - Public methods

    override open func setupConstraints(superview: UIView) {
        guard let notchConfig = viewModel.safeAreaDevice.notchConfig else {
            // No special masking required for non safe area devices.
            super.setupConstraints(superview: superview)
            return
        }

        // As we currently only support portrait mode (and no device rotation), we can safely use `bounds.size.width` here.
        let screenWidth = superview.bounds.size.width
        let notchBezierPath = self.notchBezierPath(for: screenWidth, notchConfig: notchConfig)

        // Setting the `lineWidth` draws a line, where the actual path is exactly in the middle of the drawn line.
        // To get the correct height (including the path) we have to add the `height` here to the given bounds (half height for top, half for bottom).
        let viewHeight = notchBezierPath.bounds.height + height
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
        let leftNotchPoint = (screenWidth - notchConfig.notchWidth) / 2
        let rightNotchPoint = (screenWidth + notchConfig.notchWidth) / 2

        // The center point of the large circles lays at the bottom of the small circles.
        // Please have a look at the graphic `Assets/iphone-x-screen-demystified.svg` or the entire article at
        // https://www.paintcodeapp.com/news/iphone-x-screen-demystified for further details on the notch layout.
        let smallCircleDiameter: CGFloat = 2 * notchConfig.smallCircleRadius

        // Reducing the height here a little in order to match the "basic" gradient loading bar.
        let height = self.height - 0.5

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
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + notchConfig.largeCircleRadius + notchConfig.largeCircleOffset.x,
                                              y: smallCircleDiameter + notchConfig.largeCircleOffset.y),
                          radius: notchConfig.largeCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint - notchConfig.largeCircleRadius - notchConfig.largeCircleOffset.x,
                             y: smallCircleDiameter + notchConfig.largeCircleRadius + notchConfig.largeCircleOffset.y)

        // Draw the large circle left to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - notchConfig.largeCircleRadius - notchConfig.largeCircleOffset.x,
                                              y: smallCircleDiameter + notchConfig.largeCircleOffset.y),
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

        // Have the small-circle at the bottom-path only ⅔ of the size of the upper-path produced visually better results.
        let bottomPathSmallCircleRadius = (notchConfig.smallCircleRadius / 3) * 2

        // Draw line down.
        bezierPath.addLineTo(x: screenWidth,
                             y: height)

        // Draw line to small-circle underneath and right to `rightNotchPoint`.
        bezierPath.addLineTo(x: height + rightNotchPoint + bottomPathSmallCircleRadius,
                             y: height)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: height + rightNotchPoint + bottomPathSmallCircleRadius,
                                              y: height + bottomPathSmallCircleRadius),
                          radius: bottomPathSmallCircleRadius,
                          startAngle: CGFloat.pi + CGFloat.pi / 2,
                          endAngle: CGFloat.pi,
                          clockwise: false)

        // Draw the large circle left to the `rightNotchPoint`.
        //
        // We explicitly ignore the horizontal offset (`notchConfig.largeCircleOffset.x`) here, to have the paths of the
        // small- and large-circles end/begin on the same point on the x-axis.
        bezierPath.addArc(withCenter: CGPoint(x: height + rightNotchPoint - notchConfig.largeCircleRadius,
                                              y: height + smallCircleDiameter + notchConfig.largeCircleOffset.y),
                          radius: notchConfig.largeCircleRadius,
                          startAngle: 0,
                          endAngle: CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to large-circle underneath and right to `leftNotchPoint`
        //
        // We explicitly ignore the horizontal offset (`notchConfig.largeCircleOffset.x`) here, to have the paths of the
        // small- and large-circles end/begin on the same point on the x-axis.
        bezierPath.addLineTo(x: height + leftNotchPoint + notchConfig.largeCircleRadius,
                             y: height + smallCircleDiameter + notchConfig.largeCircleRadius + notchConfig.largeCircleOffset.y)

        // Draw the large circle right to the `leftNotchPoint`.
        //
        // We explicitly ignore the horizontal offset (`notchConfig.largeCircleOffset.x`) here, to have the paths of the
        // small- and large-circles end/begin on the same point on the x-axis.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - height + notchConfig.largeCircleRadius,
                                              y: height + smallCircleDiameter + notchConfig.largeCircleOffset.y),
                          radius: notchConfig.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: CGFloat.pi,
                          clockwise: true)

        // Draw the small circle left to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - height - bottomPathSmallCircleRadius,
                                              y: height + bottomPathSmallCircleRadius),
                          radius: bottomPathSmallCircleRadius,
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

// MARK: - Helpers

private extension NotchGradientLoadingBarViewModel.SafeAreaDevice {
    /// The notch specific configuration for the current device.
    var notchConfig: NotchConfig? {
        switch self {
        case .unknown:
            return nil

        case .iPhoneX:
            /// The default configuration for the iPhone X and 11.
            /// Values are based on <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>.
            return NotchConfig(notchWidth: 208,
                               largeCircleRadius: 22.5,
                               largeCircleOffset: CGPoint(x: 0, y: -4.75),
                               transform: CGAffineTransform(translationX: 0.33, y: 0))

        case .iPhoneXR, .iPhone11:
            return NotchConfig(notchWidth: 232,
                               largeCircleRadius: 24,
                               largeCircleOffset: CGPoint(x: 0.5, y: -3.5),
                               transform: .identity)

        case .iPhone12:
            return NotchConfig(notchWidth: 209.5,
                               largeCircleRadius: 21,
                               largeCircleOffset: CGPoint(x: 0, y: -1.75),
                               transform: .identity)

        case .iPhone13:
            // The iPhone 13 specific configuration: ‟iPhone 13 notch is 20% smaller in width, but it is also a little taller in height‟.
            // Source: <https://9to5mac.com/2021/09/14/iphone-13-notch-smaller-but-bigger>.
            return NotchConfig(notchWidth: 161,
                               largeCircleRadius: 22,
                               largeCircleOffset: CGPoint(x: 0, y: -1),
                               transform: .identity)
        }
    }
}

private extension UIBezierPath {
    // swiftlint:disable:next identifier_name
    func addLineTo(x: CGFloat, y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }
}
