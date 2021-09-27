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
    // MARK: - Config

    private struct Config {
        /// The default configuration for the iPhone X, 11 and 12.
        /// Values are based on <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>.
        static let `default` = Config(notchWidth: 210,
                                      largeCircleRadius: 21,
                                      verticalOffsetForLargeCircle: -2)

        // The iPhone 13 specific configuration: ‟iPhone 13 notch is 20% smaller in width, but it is also a little taller in height‟.
        // Source: <https://9to5mac.com/2021/09/14/iphone-13-notch-smaller-but-bigger>.
        static let iPhone13Device = Config(notchWidth: 161.5,
                                           largeCircleRadius: 22,
                                           verticalOffsetForLargeCircle: -1)

        /// The width of the iPhone notch.
        let notchWidth: CGFloat

        /// The radius of the small circle on the outside of the notch.
        let smallCircleRadius: CGFloat = 6

        /// The radius of the large circle on the inside of the notch.
        let largeCircleRadius: CGFloat

        // We're moving the the large-circles a bit up.
        // This prevents having a straight line between the circles.
        // See <https://medium.com/tall-west/no-cutting-corners-on-the-iphone-x-97a9413b94e>
        let verticalOffsetForLargeCircle: CGFloat
    }

    // MARK: - Private properties

    ///
    private var adaptedLoadingBarHeight: CGFloat {
        height + 1
    }

    // MARK: - Public methods

    override open func setupConstraints(superview: UIView) {
        guard #available(iOS 11.0, *) else {
            /// The notch is only available when supporting safe area layout guides, which is starting from iOS 11.
            super.setupConstraints(superview: superview)
            return
        }

        // The `safeAreaInsets.top` always includes the status-bar and therefore will always be greater "0".
        // As a workaround we check the bottom inset.
        let hasNotch = superview.safeAreaInsets.bottom > 0

        // The iPad also has a bottom inset, in order to avoid the home indicator. (https://developer.apple.com/forums/thread/110724)
        // As a workaround we explicitly make sure to have a phone device.
        let isIPhone = UIDevice.current.userInterfaceIdiom == .phone

        guard hasNotch, isIPhone else {
            // No special masking required for non safe area devices.
            super.setupConstraints(superview: superview)
            return
        }

        // As we currently only support portrait mode (and no device rotation), we can safely use `bounds.size.width` here.
        let screenWidth = superview.bounds.size.width
        let notchBezierPath = self.notchBezierPath(for: screenWidth,
                                                   config: UIDevice.isAnyIPhone13Device ? .iPhone13Device : .default)

        // Setting the `lineWidth` draws a line, where the actual path is exactly in the middle of the drawn line.
        // Therefore we have to add the `adaptedLoadingBarHeight` here to the bounds.
        let viewHeight = notchBezierPath.bounds.height + adaptedLoadingBarHeight
        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.topAnchor.constraint(equalTo: superview.topAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: viewHeight),

            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])

        maskView(with: notchBezierPath)
    }

    // MARK: - Private methods

    private func notchBezierPath(for screenWidth: CGFloat, config: Config) -> UIBezierPath {
        // We always center the notch in the middle of the screen.
        let leftNotchPoint = (screenWidth - config.notchWidth) / 2
        let rightNotchPoint = (screenWidth + config.notchWidth) / 2

        // The center point of the large circles lays at the bottom of the small circles.
        // See graphic https://www.paintcodeapp.com/news/iphone-x-screen-demystified for further details.
        let smallCircleDiameter: CGFloat = 2 * config.smallCircleRadius

        // Setting the `lineWidth` draws a line, where the actual path is exactly in the middle of the drawn line.
        let halfStrokeSize = height / 2

        let bezierPath = UIBezierPath()
        bezierPath.moveTo(x: 0, y: halfStrokeSize)

        // Draw line to small-circle left to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint - halfStrokeSize - config.smallCircleRadius,
                             y: halfStrokeSize)

        // Draw the small circle left to the `leftNotchPoint`.
        // See <https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init#1965853> for the definition of the
        // angles in the default coordinate system.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - halfStrokeSize - config.smallCircleRadius,
                                              y: halfStrokeSize + config.smallCircleRadius),
                          radius: config.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: true)

        // Draw the large circle right to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - halfStrokeSize + config.largeCircleRadius,
                                              y: halfStrokeSize + smallCircleDiameter + config.verticalOffsetForLargeCircle),
                          radius: config.largeCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: halfStrokeSize + rightNotchPoint - config.largeCircleRadius,
                             y: halfStrokeSize + smallCircleDiameter + config.largeCircleRadius + config.verticalOffsetForLargeCircle)

        // Draw the large circle left to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: halfStrokeSize + rightNotchPoint - config.largeCircleRadius,
                                              y: halfStrokeSize + smallCircleDiameter + config.verticalOffsetForLargeCircle),
                          radius: config.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: false)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: halfStrokeSize + rightNotchPoint + config.smallCircleRadius,
                                              y: halfStrokeSize + config.smallCircleRadius),
                          radius: config.smallCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi + CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: halfStrokeSize)

        return bezierPath
    }

    private func maskView(with bezierPath: UIBezierPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = adaptedLoadingBarHeight
        shapeLayer.strokeColor = UIColor.white.cgColor

        // Explicitly set to `nil` to avoid having a filled shape, showing the gradient behind the notch
        // in the app switcher.
        shapeLayer.fillColor = nil

        if #available(iOS 13.0, *) {
            shapeLayer.cornerCurve = .continuous
        }

        gradientActivityIndicatorView.layer.mask = shapeLayer
    }
}

// MARK: - Helpers

private extension UIBezierPath {
    // swiftlint:disable:next identifier_name
    func moveTo(x: CGFloat, y: CGFloat) {
        move(to: CGPoint(x: x, y: y))
    }

    // swiftlint:disable:next identifier_name
    func addLineTo(x: CGFloat, y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }
}

private extension UIDevice {
    private enum Config {
        static let iPhone13Identifiers = ["iPhone14,5", "iPhone14,2", "iPhone14,3"]
    }

    /// Starting from the iPhone 13 the notch is smaller, but a little bit higher.
    /// Therefore we explicitly need to detect any iPhone 13 device for an adapted notch calculation.
    ///
    /// Based on: <https://stackoverflow.com/a/26962452/3532505>
    ///           Adapted for Simulator usage based on <https://stackoverflow.com/a/46380596/3532505>
    static var isAnyIPhone13Device: Bool {
        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
        #else
            var systemInfo = utsname()
            uname(&systemInfo)

            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else {
                    return identifier
                }

                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        return Config.iPhone13Identifiers.contains(identifier)
    }
}
