//
//  GradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12/11/16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

/// Typealias for controller to match pod name.
public typealias GradientLoadingBar = GradientLoadingBarController

/// The `GradientLoadingBarController` mediates between the `GradientLoadingBarViewModel` and the corresponding `GradientActivityIndicatorView`.
open class GradientLoadingBarController {
    // MARK: - Public properties

    /// The height of the gradient bar.
    ///  - Note: Has to be public to allow overwriting `setupConstraints()`
    public let height: CGFloat

    /// Flag whether the top layout constraint should respect `safeAreaLayoutGuide`.
    ///  - Note: Has to be public to allow overwriting `setupConstraints()`
    public let isRelativeToSafeArea: Bool

    /// View containing the gradient layer.
    public let gradientView = GradientActivityIndicatorView()

    /// Colors used for the gradient.
    public var gradientColors: [UIColor] {
        get {
            return gradientView.gradientColors
        }
        set {
            gradientView.gradientColors = newValue
        }
    }

    /// Duration for the progress animation.
    public var progressAnimationDuration: TimeInterval {
        get {
            return gradientView.progressAnimationDuration
        }
        set {
            gradientView.progressAnimationDuration = newValue
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
        gradientView.fadeOut(duration: 0)

        bindViewModelToView()
    }

    // MARK: - Private methods

    private func bindViewModelToView() {
        viewModel.superview.subscribeDistinct { [weak self] newSuperview, _ in
            self?.updateSuperview(newSuperview)
        }.disposed(by: &disposeBag)
    }

    private func updateSuperview(_ superview: UIView?) {
        // If the view’s superview is not nil, the superview releases the view.
        gradientView.removeFromSuperview()

        if let superview = superview {
            gradientView.translatesAutoresizingMaskIntoConstraints = false
            superview.addSubview(gradientView)

            setupConstraints(superview: superview)
        }
    }

    // MARK: - Public methods

    /// Apply layout contraints for gradient loading view.
    open func setupConstraints(superview: UIView) {
        let superViewTopAnchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *), isRelativeToSafeArea {
            superViewTopAnchor = superview.safeAreaLayoutGuide.topAnchor
        } else {
            superViewTopAnchor = superview.topAnchor
        }

        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: superViewTopAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: height),

            gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }

    /// Fades in the gradient loading bar.
    public func fadeIn(duration: TimeInterval = TimeInterval.GradientLoadingBar.fadeInDuration, completion: ((Bool) -> Void)? = nil) {
        gradientView.fadeIn(duration: duration,
                            completion: completion)
    }

    /// Fades out the gradient loading bar.
    public func fadeOut(duration: TimeInterval = TimeInterval.GradientLoadingBar.fadeOutDuration, completion: ((Bool) -> Void)? = nil) {
        gradientView.fadeOut(duration: duration,
                             completion: completion)
    }
}
