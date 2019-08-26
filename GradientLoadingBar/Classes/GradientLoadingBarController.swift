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

/// The `GradientLoadingBarController` mediates between the `GradientLoadingBarViewModel` and the corresponding `GradientView`.
open class GradientLoadingBarController {
    // MARK: - Public properties

    /// The height of the gradient bar.
    ///  - Note: Has to be public to allow overwriting `setupConstraints()`
    public let height: Double

    /// Flag whether the top layout constraint should respect `safeAreaLayoutGuide`.
    ///  - Note: Has to be public to allow overwriting `setupConstraints()`
    public let isRelativeToSafeArea: Bool

    ///
    public var fadeInDuration: Double {
        get {
            return viewModel.fadeInDuration
        }
        set {
            viewModel.fadeInDuration = newValue
        }
    }

    ///
    public var fadeOutDuration: Double {
        get {
            return viewModel.fadeOutDuration
        }
        set {
            viewModel.fadeOutDuration = newValue
        }
    }

    /// View containing the gradient layer.
    public let gradientView = GradientActivityIndicatorView()

    /// Singleton instance.
    public static var shared = GradientLoadingBar()

    // MARK: - Private properties

    /// View model containing logic for the gradient view.
    private let viewModel: GradientLoadingBarViewModel

    /// The dispose bag for the observables.
    private var disposeBag = DisposeBag()

    // MARK: - Initializers

    /// Creates a new gradient loading bar instance.
    ///
    /// Parameters:
    ///  - height:               Height of the gradient bar.
    ///  - gradientColors:       Colors used for the gradient.
    ///  - isRelativeToSafeArea: Flag whether the top layout constraint should respect `safeAreaLayoutGuide`.
    ///
    /// Returns: Instance with gradient bar
    public init(height: Double = 2.5,
                gradientColors: [UIColor] = UIColor.GradientLoadingBar.gradientColors,
                isRelativeToSafeArea: Bool = true) {
        self.height = height
        self.isRelativeToSafeArea = isRelativeToSafeArea

        gradientView.gradientColors = gradientColors
        gradientView.alpha = 0.0
        gradientView.isHidden = true

        viewModel = GradientLoadingBarViewModel()
        bindViewModelToView()
    }

    /// By providing a custom deinitializer we make sure to remove the corresponding `gradientView` from its superview.
    deinit {
        if gradientView.superview != nil {
            gradientView.removeFromSuperview()
        }
    }

    // MARK: - Private methods

    private func bindViewModelToView() {
        viewModel.visibilityAnimation.subscribeDistinct { [weak self] newVisibilityAnimation, _ in
            self?.gradientView.animate(isHidden: newVisibilityAnimation.isHidden,
                                       duration: newVisibilityAnimation.duration)
        }.disposed(by: &disposeBag)

        viewModel.superview.subscribeDistinct { [weak self] newSuperview, _ in
            self?.addGradientView(to: newSuperview)
        }.disposed(by: &disposeBag)
    }

    private func addGradientView(to superview: UIView?) {
        guard let superview = superview else {
            // We've received an invalid superview.
            return
        }

        gradientView.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(gradientView)

        setupConstraints(superview: superview)
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
}
