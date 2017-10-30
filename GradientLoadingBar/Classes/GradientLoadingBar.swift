//
//  GradientLoadingBar.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

// Handler for GradientView
open class GradientLoadingBar {

    public struct DefaultValues {
        public static let height = 2.5

        public static let durations =
            Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)

        // iOS color palette
        // From: http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/
        public static let gradientColors: GradientColors = [
            UIColor(hexString:"#4cd964").cgColor,
            UIColor(hexString:"#5ac8fa").cgColor,
            UIColor(hexString:"#007aff").cgColor,
            UIColor(hexString:"#34aadc").cgColor,
            UIColor(hexString:"#5856d6").cgColor,
            UIColor(hexString:"#ff2d55").cgColor
        ]
    }

    /// View containing the gradient view.
    public var superview: UIView?

    /// View with the gradient layer.
    public let gradientView: GradientView

    /// Boolean flag, true if gradient view is currently visible, otherwise false.
    /// Used to handle mutliple calls to show at the same time.
    public private(set) var isVisible = false

    /// Height of gradient bar.
    public private(set) var height = 0.0
    
    /// Singleton instance.
    public static var shared = GradientLoadingBar()

    // MARK: - Initializers

    /// Creates a new gradient loading bar instance.
    ///
    /// Parameters:
    ///  - height:         Height of the gradient bar
    ///  - durations:      Configuration with durations for each animation
    ///  - gradientColors: Colors used for the gradient
    ///  - superview:      View containing the gradient bar
    ///
    /// Returns: Instance with gradient bar
    public init (
        height: Double = DefaultValues.height,
        durations: Durations = DefaultValues.durations,
        gradientColors: GradientColors = DefaultValues.gradientColors,
        onView superview: UIView? = UIApplication.shared.keyWindow
    ) {
        self.height = height
        self.superview = superview

        gradientView = GradientView(
            durations: durations,
            gradientColors: gradientColors
        )

        addGradientViewToSuperview()
    }

    deinit {
        if gradientView.superview != nil {
            gradientView.removeFromSuperview()
        }
    }

    // MARK: - Layout

    private func addGradientViewToSuperview() {
        // If initializer called in "appDelegate" key window will not be available..
        guard let superview = superview else {
            // .. so we setup an observer to add "gradientView" to key window (by saving it as superview) when it's ready.
            let notificationCenter = NotificationCenter.default
            notificationCenter.observeOnce(forName: NSNotification.Name.UIWindowDidBecomeKey) { (_ notification) in
                self.superview = UIApplication.shared.keyWindow
                self.addGradientViewToSuperview()
            }

            // Stop here and wait for observer to finish.
            return
        }

        // Add gradient view to superview..
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(gradientView)

        // .. and apply layout anchors.
        setupConstraints()
    }

    /// Apply layout contraints for gradient loading view.
    open func setupConstraints() {
        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            
            gradientView.topAnchor.constraint(equalTo: superview.topAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        ])
    }

    // MARK: - Helper to use as a Singleton

    /// Saves the current instance as instance for singleton.
    @available(*, deprecated, message: "use .shared instead")
    public func saveInstance() {
        type(of: self).shared = self
    }

    /// Singleton instance.
    @available(*, deprecated, message: "use .shared instead")
    public static func sharedInstance() -> GradientLoadingBar {
        return shared
    }

    // MARK: - Show / Hide

    /// Fade in the gradient loading bar.
    public func show() {
        if !isVisible {
            isVisible = true

            gradientView.show()
        }
    }

    /// Fade out the gradient loading bar.
    public func hide() {
        if isVisible {
            isVisible = false

            gradientView.hide()
        }
    }

    /// Toggle visiblity of gradient loading bar.
    public func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }
}
