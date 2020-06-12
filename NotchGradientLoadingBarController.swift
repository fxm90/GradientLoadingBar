//
//  NotchGradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11.06.20.
//

import UIKit

///
@available(iOS 11.0, *)
public typealias NotchGradientLoadingBar = NotchGradientLoadingBarController

@available(iOS 11.0, *)
open class NotchGradientLoadingBarController: GradientLoadingBarController {
    // MARK: - Config

    /// Values are based on
    /// <https://www.paintcodeapp.com/news/iphone-x-screen-demystified>
    private enum Config {
        /// The width of the iPhone notch.
        static let notchWidth: CGFloat = 209

        /// The radius of the small circle on the outside of the notch.
        static let smallCircleRadius: CGFloat = 6

        /// The radius of the large circle on the inside of the notch.
        static let largeCircleRadius: CGFloat = 20
    }

    // MARK: - Public methods

    override open func setupConstraints(superview: UIView) {
        // Our view will be masked therefore the view height needs to cover both circles plus the given user-height.
        let height = 2 * Config.smallCircleRadius + Config.largeCircleRadius + self.height

        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.topAnchor.constraint(equalTo: superview.topAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: height),

            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])

        applyNotchMask()
    }

    // MARK: - Private methods

    private func applyNotchMask() {
        // We draw the mask of the notch in the center of the screen.
        // As we currently only support portrait mode, we can safely use `UIScreen.main.bounds` here.
        let screenWidth = UIScreen.main.bounds.size.width
        let leftNotchPoint = (screenWidth - Config.notchWidth) / 2
        let rightNotchPoint = (screenWidth + Config.notchWidth) / 2

        let smallCircleDiameter: CGFloat = 2 * Config.smallCircleRadius

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))

        // Draw line to small-circle left to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint - Config.smallCircleRadius,
                             y: 0)

        // Draw the small circle left to the `leftNotchPoint`.
        // See <https://developer.apple.com/documentation/uikit/uibezierpath/1624358-init#1965853> for the definition of the
        // angles in the default coordinate system.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - Config.smallCircleRadius,
                                              y: Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: true)

        // Draw the large circle right to the `leftNotchPoint`.
        // Moving it up by two points looked way better.
        let verticalOffsetForLargeCenterPoint: CGFloat = 2
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCenterPoint),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint - Config.largeCircleRadius,
                             y: smallCircleDiameter + Config.largeCircleRadius - verticalOffsetForLargeCenterPoint)

        // Draw the large circle left to the `rightNotchPoint`.
        // Moving it up by two points looked way better.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCenterPoint),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: false)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + Config.smallCircleRadius,
                                              y: Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi + CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: 0)

        // And go back..
        // Therefore we always to offset the given `height` by the user.
        // Start by moving down at the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: height)

        // Draw line to small-circle right to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint + Config.smallCircleRadius + height,
                             y: height)

        // Draw the small circle right to the `rightNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + Config.smallCircleRadius + height,
                                              y: Config.smallCircleRadius + height),
                          radius: Config.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: -CGFloat.pi,
                          clockwise: false)

        // Draw the large circle left to the `rightNotchPoint`.
        // Moving it up by two points looked way better.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - Config.largeCircleRadius + height,
                                              y: smallCircleDiameter - verticalOffsetForLargeCenterPoint + height),
                          radius: Config.largeCircleRadius,
                          startAngle: 0,
                          endAngle: CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to large-circle underneath and right to `leftNotchPoint`.
        bezierPath.addLineTo(x: leftNotchPoint + Config.largeCircleRadius + height,
                             y: smallCircleDiameter + Config.largeCircleRadius - verticalOffsetForLargeCenterPoint + height)

        // Draw the large circle right to the `leftNotchPoint`.
        // Moving it up by two points looked way better.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + Config.largeCircleRadius - height,
                                              y: smallCircleDiameter - verticalOffsetForLargeCenterPoint + height),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: CGFloat.pi,
                          clockwise: true)

        // Draw the small circle left to the `leftNotchPoint`.
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - Config.smallCircleRadius - height,
                                              y: Config.smallCircleRadius + height),
                          radius: Config.smallCircleRadius,
                          startAngle: 0,
                          endAngle: -CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to the beginning of the screen.
        bezierPath.addLineTo(x: 0, y: height)
        bezierPath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath

        // Our shape is not perfect, therefore we move it up by one point, so no background is visible between our shape and
        // the frame of the smartphone.
        shapeLayer.position = CGPoint(x: 0, y: -1)

        gradientActivityIndicatorView.layer.mask = shapeLayer
    }
}

// MARK: - Helpers

private extension UIBezierPath {
    // swiftlint:disable:next identifier_name
    func addLineTo(x: CGFloat, y: CGFloat) {
        addLine(to: CGPoint(x: x, y: y))
    }
}
