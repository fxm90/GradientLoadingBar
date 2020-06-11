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
        /// The width of the iPhone notch (a little bit larger than mentioned in the docs).
        static let notchWidth: CGFloat = 211

        /// The radius of the small circle on the outside of the notch.
        static let smallCircleRadius: CGFloat = 6

        /// The radius of the small circle on the inside of the notch.
        static let largeCircleRadius: CGFloat = 20
    }

    // MARK: - Public methods

    override open func setupConstraints(superview: UIView) {
        //
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

        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint - Config.smallCircleRadius, y: Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: -CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: true)

        // Draw the large-circle.
        // Moving it up by two points looked way better.
        let verticalOffsetForLargeCenterPoint: CGFloat = 2
        bezierPath.addArc(withCenter: CGPoint(x: leftNotchPoint + Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCenterPoint),
                          radius: Config.largeCircleRadius,
                          startAngle: -CGFloat.pi,
                          endAngle: CGFloat.pi / 2,
                          clockwise: false)

        // Draw line to large-circle underneath and left to `rightNotchPoint`.
        bezierPath.addLineTo(x: rightNotchPoint - Config.largeCircleRadius,
                             y: smallCircleDiameter + Config.largeCircleRadius - verticalOffsetForLargeCenterPoint)

        // Draw the large-circle.
        // Moving it up by two points looked way better.
        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint - Config.largeCircleRadius,
                                              y: smallCircleDiameter - verticalOffsetForLargeCenterPoint),
                          radius: Config.largeCircleRadius,
                          startAngle: CGFloat.pi / 2,
                          endAngle: 0,
                          clockwise: false)

        bezierPath.addArc(withCenter: CGPoint(x: rightNotchPoint + Config.smallCircleRadius, y: Config.smallCircleRadius),
                          radius: Config.smallCircleRadius,
                          startAngle: CGFloat.pi,
                          endAngle: CGFloat.pi + CGFloat.pi / 2,
                          clockwise: true)

        // Draw line to the end of the screen.
        bezierPath.addLineTo(x: screenWidth, y: 0)
        bezierPath.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.path = bezierPath.cgPath

        // As the stroke lays outside of our bezier-path and only one-half of the stroke is visible (the other part is hidden behind the frame
        // of the smartphone), we have to multiply it by two.
        shapeLayer.lineWidth = 2 * height

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
