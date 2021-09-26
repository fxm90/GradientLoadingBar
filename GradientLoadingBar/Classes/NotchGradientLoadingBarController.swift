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

    /// Values are based on
    /// <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>
    ///
    /// Values for the iPhone 13 are based on testing in the simulator.
    private enum Config {
        /// The width of the iPhone notch.
        static let notchWidth: CGFloat = UIDevice.isAnyIPhone13Device ? 162 : 210

        /// The radius of the small circle on the outside of the notch.
        static let smallCircleRadius: CGFloat = 6

        /// The radius of the large circle on the inside of the notch.
        static let largeCircleRadius: CGFloat = UIDevice.isAnyIPhone13Device ? 22 : 21
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
        let notchBezierPath = self.notchBezierPath(for: screenWidth)

        // Setting the lineWidth draws a line, where the actual path is exactly in the middle of the drawn line.
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

    private func notchBezierPath(for screenWidth: CGFloat) -> UIBezierPath {
        // We always center the notch in the middle of the screen.
        let leftNotchPoint = (screenWidth - Config.notchWidth) / 2
        let rightNotchPoint = (screenWidth + Config.notchWidth) / 2

        let smallCircleDiameter: CGFloat = 2 * Config.smallCircleRadius

        // Setting the `lineWidth` draws a line, where the actual path is exactly in the middle of the drawn line.
        let halfStrokeSize = height / 2

        let bezierPath = UIBezierPath()
        bezierPath.moveTo(x: 0, y: halfStrokeSize)

        // Draw line to small-circle left to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint - halfStrokeSize - Config.smallCircleRadius,
                             y: halfStrokeSize)

        // Draw the small circle left to the `leftNotchPoint`.
        // See <https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init#1965853> for the definition of the
        // angles in the default coordinate system.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - halfStrokeSize - Config.smallCircleRadius,
                                              y: halfStrokeSize + Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: true)

        // We're moving the the large-circles a bit up.
        // This prevents having a straight line between the circles.
        // See <https://medium.com/tall-west/no-cutting-corners-on-the-iphone-x-97a9413b94e>
        //
        // But for the iPhone 13 we reduce this value: ‟iPhone 13 notch is 20% smaller in width, but it is also a little taller in height‟.
        // See <https://9to5mac.com/2021/09/14/iphone-13-notch-smaller-but-bigger>.
        let verticalOffsetForLargeCircle: CGFloat = UIDevice.isAnyIPhone13Device ? -1 : -2

        // Draw the large circle right to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - halfStrokeSize + Config.largeCircleRadius,
                                              y: halfStrokeSize + smallCircleDiameter + verticalOffsetForLargeCircle),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: halfStrokeSize + rightNotchPoint - Config.largeCircleRadius,
                             y: halfStrokeSize + smallCircleDiameter + Config.largeCircleRadius + verticalOffsetForLargeCircle)

        // Draw the large circle left to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: halfStrokeSize + rightNotchPoint - Config.largeCircleRadius,
                                              y: halfStrokeSize + smallCircleDiameter + verticalOffsetForLargeCircle),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: false)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: halfStrokeSize + rightNotchPoint + Config.smallCircleRadius,
                                              y: halfStrokeSize + Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
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

        let iPhone13Identifiers = ["iPhone14,5", "iPhone14,2", "iPhone14,3"]
        return iPhone13Identifiers.contains(identifier)
    }
}
