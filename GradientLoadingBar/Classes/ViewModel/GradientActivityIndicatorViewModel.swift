//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

/// Classes implementing this delegate protocol will get notified about animation changes.
///
/// - Note: Unfortunatly `LightweightObservable` doesn't support signals (yet), therefore we fallback to a delegate pattern
///         for the signal to restart the animation.
protocol GradientActivityIndicatorViewModelDelegate: AnyObject {
    /// Informs the delegate to restart the animation, as some related values have changed.
    func restartAnimation()
}

/// This view model contains all logic related to the `GradientActivityIndicatorView`.
final class GradientActivityIndicatorViewModel {
    // MARK: - Public properties

    /// Observable state of the progress animation.
    var isAnimatingProgress: Observable<Bool> {
        return isAnimatingProgressSubject.asObservable
    }

    /// Observable frame of the gradient layer.
    var gradientLayerFrame: Observable<CGRect> {
        return gradientLayerFrameSubject.asObservable
    }

    /// Observable starting point (x) of the animation of the gradient layer.
    var gradientLayerAnimationFromValue: Observable<CGFloat> {
        return gradientLayerAnimationFromValueSubject.asObservable
    }

    /// Observable duration of the animation of the gradient layer.
    var gradientLayerAnimationDuration: Observable<TimeInterval> {
        return gradientLayerAnimationDurationSubject.asObservable
    }

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: Observable<[CGColor]> {
        return gradientLayerColorsSubject.asObservable
    }

    /// Boolean flag, whether the view is currently hidden.
    var isHidden = false {
        didSet {
            isAnimatingProgressSubject.value = !isHidden
        }
    }

    /// The bounds of the view.
    var bounds: CGRect = .zero {
        didSet {
            // Three times of the width in order to apply normal, reversed and normal gradient to simulate infinte animation.
            gradientLayerFrameSubject.value = CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)

            // Update `fromValue` of animation accordingly.
            gradientLayerAnimationFromValueSubject.value = -2 * bounds.size.width

            updateProgressAnimationIfNeeded()
        }
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = makeGradientLayerColors()
        }
    }

    /// The duration for the progress animation.
    var progressAnimationDuration = TimeInterval.GradientLoadingBar.progressDuration {
        didSet {
            gradientLayerAnimationDurationSubject.value = progressAnimationDuration

            updateProgressAnimationIfNeeded()
        }
    }

    weak var delegate: GradientActivityIndicatorViewModelDelegate?

    // MARK: - Private properties

    // As our view is initially visible, we also have to start the progress animation initially.
    private let isAnimatingProgressSubject: Variable<Bool> = Variable(true)

    private let gradientLayerFrameSubject: Variable<CGRect> = Variable(.zero)

    private let gradientLayerAnimationFromValueSubject: Variable<CGFloat> = Variable(0.0)

    private let gradientLayerAnimationDurationSubject: Variable<TimeInterval>

    private let gradientLayerColorsSubject: Variable<[CGColor]>

    // MARK: - Initializer

    init() {
        gradientLayerAnimationDurationSubject = Variable(progressAnimationDuration)

        // Small workaround as calls to `self.makeGradientLayerColors()` aren't allowed before all properties have been initialized.
        gradientLayerColorsSubject = Variable([])
        gradientLayerColorsSubject.value = makeGradientLayerColors()
    }

    // MARK: - Private methods

    /// Maps the current `gradientColors` given by the user as an array of `UIColor`,
    /// to an array of type `CGColor`, so we can use it for our gradient layer.
    private func makeGradientLayerColors() -> [CGColor] {
        // Simulate infinte animation - Therefore we'll reverse the colors and remove the first and last item
        // to prevent duplicate values at the "inner edges" destroying the infinite look.
        let reversedColors = gradientColors
            .reversed()
            .dropFirst()
            .dropLast()

        let infiniteGradientColors = gradientColors + reversedColors + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }

    /// Unfortunatly the only easy way to update a running `CABasicAnimation`, is to restart it.
    /// Mutating a running animation throws an exception!!
    private func updateProgressAnimationIfNeeded() {
        guard isAnimatingProgress.value else { return }

        delegate?.restartAnimation()
    }
}
