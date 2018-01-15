//
//  GradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import UIKit

// MARK: - Typealiases

/// Typealias for controller to match pod name.
public typealias GradientLoadingBar = GradientLoadingBarController

/// Array with gradient colors.
public typealias GradientColors = [CGColor]

// MARK: - Controller

open class GradientLoadingBarController {

    // MARK: - Types

    /// Struct used for default parameters in initialization
    public struct DefaultValues {

        /// Height of gradient bar.
        public static let height = 2.5

        /// Configuration with durations for each animation.
        public static let durations = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)

        // iOS color palette
        // From: http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/
        public static let gradientColors: GradientColors = [
            UIColor(hex: "#4cd964").cgColor,
            UIColor(hex: "#5ac8fa").cgColor,
            UIColor(hex: "#007aff").cgColor,
            UIColor(hex: "#34aadc").cgColor,
            UIColor(hex: "#5856d6").cgColor,
            UIColor(hex: "#ff2d55").cgColor
        ]
    }

    // MARK: - Public properties

    /// Boolean flag, true if gradient view is currently visible, otherwise false.
    public var isVisible: Bool {
        return viewModel.isVisible
    }

    /// View containing the gradient layer.
    public let gradientView: GradientView

    /// Height of gradient bar.
    public private(set) var height = 0.0

    /// Superview that the gradient view is attached to.
    public private(set) var superview: UIView?
    
    /// Singleton instance.
    public static var shared: GradientLoadingBar = GradientLoadingBar()

    // MARK: - Private properties

    /// View model containing logic for the gradient view.
    private let viewModel = GradientLoadingBarViewModel()

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
        onView superview: UIView? = nil
    ) {
        self.height = height

        gradientView = GradientView(
            animationDurations: durations,
            gradientColors: gradientColors
        )

        viewModel.delegate = self

        if let superview = superview {
            // We have a custom superview given from the user, therefore add gradient view immediatly.
            self.superview = superview
            addGradientViewToSuperview()
        } else {
            // No superview given, let the view model notify us when `keyWindow` becomes available.
            viewModel.setupObserverForKeyWindow()
        }
    }

    deinit {
        if gradientView.superview != nil {
            gradientView.removeFromSuperview()
        }
    }

    // MARK: - Layout

    private func addGradientViewToSuperview() {
        guard let superview = superview else { return }

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(gradientView)

        setupConstraints()
    }

    /// Apply layout contraints for gradient loading view.
    open func setupConstraints() {
        guard let superview = superview else { return }

        let topLayoutConstraint: NSLayoutConstraint
        if #available(iOS 11.0, *), superview.hasTopSafeAreaInset {
            // Handle iPhone X Layout, so gradient view is underneath the status bar
            topLayoutConstraint = gradientView.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor)
        } else {
            topLayoutConstraint = gradientView.topAnchor.constraint(equalTo: superview.topAnchor)
        }

        NSLayoutConstraint.activate([
            topLayoutConstraint,
            gradientView.heightAnchor.constraint(equalToConstant: CGFloat(height)),

            gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }

    // MARK: - Helper to use class as a singleton

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

    // MARK: - Show / Hide (proxy methods to hide view model implementation)

    /// Fade in the gradient loading bar.
    public func show() {
        viewModel.show()
    }

    /// Fade out the gradient loading bar.
    public func hide() {
        viewModel.hide()
    }

    /// Toggle visiblity of gradient loading bar.
    public func toggle() {
        viewModel.toggle()
    }
}

// MARK: - GradientLoadingBarViewModelDelegate

extension GradientLoadingBarController: GradientLoadingBarViewModelDelegate {
    func viewModel(_ viewModel: GradientLoadingBarViewModel, didUpdateKeyWindow keyWindow: UIView) {
        guard superview == nil else {
            // The viewmodel informed us eventhough we already have a valid superview.
            // This isn't supposed to happen, therefore safely exit here.
            return
        }

        superview = keyWindow
        addGradientViewToSuperview()
    }

    func viewModel(_ viewModel: GradientLoadingBarViewModel, didUpdateVisibility visible: Bool) {
        if visible {
            gradientView.show()
        } else {
            gradientView.hide()
        }
    }
}
