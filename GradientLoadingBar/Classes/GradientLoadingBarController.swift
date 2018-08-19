//
//  GradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Observable
import UIKit

/// Typealias for controller to match pod name.
public typealias GradientLoadingBar = GradientLoadingBarController

open class GradientLoadingBarController {
    // MARK: - Types

    /// Struct used for default parameters in initialization
    public struct DefaultValues {
        /// Height of gradient bar.
        public static let height = 2.5

        /// Configuration with durations for each animation.
        public static let durations = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)

        // iOS color palette
        // From: https://codepen.io/marcobiedermann/pen/LExXWW
        public static let gradientColors = [
            UIColor(hex: "#4cd964"),
            UIColor(hex: "#5ac8fa"),
            UIColor(hex: "#007aff"),
            UIColor(hex: "#34aadc"),
            UIColor(hex: "#5856d6"),
            UIColor(hex: "#ff2d55")
        ]
    }

    // MARK: - Public properties

    /// Boolean flag, true if gradient view is currently visible, otherwise false.
    public var isVisible: Bool {
        return viewModel.isVisible.value
    }

    /// View containing the gradient layer.
    public let gradientView: GradientView

    /// Height of gradient bar.
    public let height: Double

    /// Singleton instance.
    public static var shared = GradientLoadingBar()

    // MARK: - Private properties

    /// View model containing logic for the gradient view.
    private let viewModel: GradientLoadingBarViewModel

    /// The dispose bag for the observables.
    private var disposal = Disposal()

    // MARK: - Initializers

    /// Creates a new gradient loading bar instance.
    ///
    /// Parameters:
    ///  - height:            Height of the gradient bar
    ///  - durations:         Configuration with durations for each animation
    ///  - gradientColorList: Colors used for the gradient
    ///  - superview:         View containing the gradient bar
    ///
    /// Returns: Instance with gradient bar
    public init(height: Double = DefaultValues.height,
                durations: Durations = DefaultValues.durations,
                gradientColorList: [UIColor] = DefaultValues.gradientColors,
                onView superview: UIView? = nil) {
        self.height = height

        gradientView = GradientView(animationDurations: durations,
                                    gradientColorList: gradientColorList)

        viewModel = GradientLoadingBarViewModel(superview: superview)

        bindViewModelToView()
    }

    deinit {
        if gradientView.superview != nil {
            gradientView.removeFromSuperview()
        }
    }

    // MARK: - Private methods

    private func bindViewModelToView() {
        viewModel.isVisible.observe { [weak self] nextValue, _ in
            if nextValue {
                self?.gradientView.show()
            } else {
                self?.gradientView.hide()
            }
        }.add(to: &disposal)

        viewModel.superview.observe { [weak self] nextValue, _ in
            guard self?.gradientView.superview == nil else {
                // The viewmodel informed us eventhough we already have a valid superview. This isn't supposed to happen, therefore we safely exit here.
                return
            }

            guard let superview = nextValue else {
                // We've got an invalid superview, therefore we safely exit here.
                return
            }

            self?.addGradientView(to: superview)
        }.add(to: &disposal)
    }

    private func addGradientView(to superview: UIView) {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(gradientView)

        setupConstraints(superview: superview)
    }

    // MARK: - Public methods

    /// Apply layout contraints for gradient loading view.
    open func setupConstraints(superview: UIView) {
        let superViewTopAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            // Handle iPhone X Layout, so gradient view is underneath the status bar
            superViewTopAnchor = superview.safeAreaLayoutGuide.topAnchor
        } else {
            superViewTopAnchor = superview.topAnchor
        }

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: superViewTopAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: CGFloat(height)),

            gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }

    /// Fades in the gradient loading bar.
    public func show() {
        viewModel.show()
    }

    /// Fades out the gradient loading bar.
    public func hide() {
        viewModel.hide()
    }

    /// Toggle visiblity of gradient loading bar.
    public func toggle() {
        viewModel.toggle()
    }
}

// MARK: - Deprecated methods

extension GradientLoadingBarController {
    /// Creates a new gradient loading bar instance.
    ///
    /// Note:
    ///  - Deprecated!
    ///  - Please use `init(height: Double, durations: Durations, gradientColorList: [UIColor], onView: UIView?)` instead
    ///
    /// Parameters:
    ///  - height:         Height of the gradient bar
    ///  - durations:      Configuration with durations for each animation
    ///  - gradientColors: Colors used for the gradient
    ///  - superview:      View containing the gradient bar
    ///
    /// Returns: Instance with gradient bar
    @available(*, deprecated, message: "Please use `init(height: Double, durations: Durations, gradientColorList: [UIColor], onView: UIView?)` instead")
    public convenience init(height: Double = DefaultValues.height,
                            durations: Durations = DefaultValues.durations,
                            gradientColors: [CGColor],
                            onView superview: UIView? = nil) {
        self.init(height: height,
                  durations: durations,
                  gradientColorList: gradientColors.map({ UIColor(cgColor: $0) }),
                  onView: superview)
    }

    /// Saves the current instance for usage as singleton.
    ///
    /// Note:
    ///  - Deprecated!
    ///  - Please use `.shared` instead
    ///
    @available(*, deprecated, message: "Please use `.shared` instead")
    public func saveInstance() {
        type(of: self).shared = self
    }

    /// Singleton instance.
    ///
    /// Note:
    ///  - Deprecated!
    ///  - Please use `.shared` instead
    ///
    @available(*, deprecated, message: "Please use `.shared` instead")
    public static func sharedInstance() -> GradientLoadingBar {
        return shared
    }
}
