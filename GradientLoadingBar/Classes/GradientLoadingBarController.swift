//
//  GradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12/11/16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

/// Type-alias for the controller to match pod name.
public typealias GradientLoadingBar = GradientLoadingBarController

/// The `GradientLoadingBarController` mediates between the `GradientLoadingBarViewModel` and the corresponding `GradientActivityIndicatorView`.
open class GradientLoadingBarController {
    // MARK: - Public properties

    /// The height of the gradient bar.
    ///
    ///  - Note: Has to be public to allow overwriting `setupConstraints()`
    public let height: CGFloat

    /// Flag whether the top layout constraint should respect `safeAreaLayoutGuide`.
    ///
    ///  - Note: Has to be public to allow overwriting `setupConstraints()`
    public let isRelativeToSafeArea: Bool

    /// View containing the gradient layer.
    public let gradientActivityIndicatorView = GradientActivityIndicatorView()

    /// Colors used for the gradient.
    public var gradientColors: [UIColor] {
        get {
            gradientActivityIndicatorView.gradientColors
        }
        set {
            gradientActivityIndicatorView.gradientColors = newValue
        }
    }

    /// Duration for the progress animation.
    public var progressAnimationDuration: TimeInterval {
        get {
            gradientActivityIndicatorView.progressAnimationDuration
        }
        set {
            gradientActivityIndicatorView.progressAnimationDuration = newValue
        }
    }

    /// Singleton instance.
    public static var shared = GradientLoadingBar()

    // MARK: - Private properties

    /// View model containing logic for the gradient view.
    private let viewModel = GradientLoadingBarViewModel()

    /// The dispose bag for the observables.
    private var disposeBag = DisposeBag()

    // MARK: - Initializers

    /// Creates a new gradient loading bar instance.
    ///
    /// - Parameters:
    ///   - height:               Height of the gradient bar (defaults to `3.0`).
    ///   - isRelativeToSafeArea: Flag whether the top layout constraint should respect `safeAreaLayoutGuide`.
    ///
    /// - Returns: Instance of gradient loading bar.
    public init(height: CGFloat = 3,
                isRelativeToSafeArea: Bool = true) {
        self.height = height
        self.isRelativeToSafeArea = isRelativeToSafeArea

        // We don't want the view to be visible initially.
        gradientActivityIndicatorView.fadeOut(duration: 0)

        bindViewModelToView()
    }

    deinit {
        gradientActivityIndicatorView.removeFromSuperview()
    }

    // MARK: - Public methods

    /// Apply layout constraints for gradient loading view.
    open func setupConstraints(superview: UIView) {
        let superViewTopAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *), isRelativeToSafeArea {
            superViewTopAnchor = superview.safeAreaLayoutGuide.topAnchor
        } else {
            superViewTopAnchor = superview.topAnchor
        }

        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.topAnchor.constraint(equalTo: superViewTopAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: height),

            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }

    /// Fades in the gradient loading bar.
    public func fadeIn(duration: TimeInterval = TimeInterval.GradientLoadingBar.fadeInDuration, completion: ((Bool) -> Void)? = nil) {
        gradientActivityIndicatorView.fadeIn(duration: duration,
                                             completion: completion)
    }

    /// Fades out the gradient loading bar.
    public func fadeOut(duration: TimeInterval = TimeInterval.GradientLoadingBar.fadeOutDuration, completion: ((Bool) -> Void)? = nil) {
        gradientActivityIndicatorView.fadeOut(duration: duration,
                                              completion: completion)
    }

    // MARK: - Private methods

    private func bindViewModelToView() {
        viewModel.superview.subscribeDistinct { [weak self] newSuperview, _ in
            self?.updateSuperview(newSuperview)
        }.disposed(by: &disposeBag)
    }

    private func updateSuperview(_ superview: UIView?) {
        // If the view’s superview is not nil, the superview releases the view.
        gradientActivityIndicatorView.removeFromSuperview()

        if let superview = superview {
            gradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview(gradientActivityIndicatorView)

            setupConstraints(superview: superview)
        }
    }
}
