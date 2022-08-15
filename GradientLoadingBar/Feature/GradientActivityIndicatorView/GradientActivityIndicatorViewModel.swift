//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

/// This view model contains all logic related to the `GradientActivityIndicatorView`.
final class GradientActivityIndicatorViewModel {

    // MARK: - Types

    /// - Note: The `fromValue` used on the `CABasicAnimation` is dependent on the `frame`,
    ///         therefore we always update these values together.
    struct SizeUpdate: Equatable {
        let frame: CGRect
        let fromValue: CGFloat
    }

    // MARK: - Public properties

    /// Observable state of the progress animation.
    var isAnimating: Observable<Bool> {
        isAnimatingSubject
    }

    /// Observable frame of the gradient layer.
    var gradientLayerSizeUpdate: Observable<SizeUpdate> {
        gradientLayerSizeUpdateSubject
    }

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: Observable<[CGColor]> {
        gradientLayerColorsSubject
    }

    /// Observable duration of the animation of the gradient layer.
    var gradientLayerAnimationDuration: Observable<TimeInterval> {
        gradientLayerAnimationDurationSubject
    }

    /// Boolean flag, whether the view is currently hidden.
    var isHidden = false {
        didSet {
            isAnimatingSubject.value = !isHidden
        }
    }

    /// The bounds of the view.
    var bounds: CGRect = .zero {
        didSet {
            // Three times of the width in order to apply normal, reversed and normal gradient
            // to simulate an infinite animation.
            var frame = bounds
            frame.size.width *= 3

            gradientLayerSizeUpdateSubject.value = SizeUpdate(frame: frame, fromValue: bounds.width * -2)
        }
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = gradientColors.infiniteGradientColors().map(\.cgColor)
        }
    }

    /// The duration for the progress animation.
    ///
    ///  - Note: We explicitly have to pass this value through the view-model, in order to restart the animation when this value changes
    ///          while the loading bar is visible.
    var progressAnimationDuration: TimeInterval {
        get { gradientLayerAnimationDurationSubject.value }
        set { gradientLayerAnimationDurationSubject.value = newValue }
    }

    // MARK: - Private properties

    // As a `UIView` is initially visible, we also have to start the progress animation initially.
    private let isAnimatingSubject = Variable(true)
    private let gradientLayerSizeUpdateSubject = Variable(SizeUpdate(frame: .zero, fromValue: 0))

    private let gradientLayerColorsSubject: Variable<[CGColor]>
    private let gradientLayerAnimationDurationSubject: Variable<TimeInterval>

    private var disposeBag = DisposeBag()

    // MARK: - Instance Lifecycle

    init() {
        gradientLayerColorsSubject = Variable(gradientColors.infiniteGradientColors().map(\.cgColor))
        gradientLayerAnimationDurationSubject = Variable(.GradientLoadingBar.progressDuration)

        gradientLayerAnimationDuration.subscribeDistinct { [weak self] _, _ in
            self?.restartAnimationIfNeeded()
        }.disposed(by: &disposeBag)

        gradientLayerSizeUpdate.subscribeDistinct { [weak self] _, _ in
            self?.restartAnimationIfNeeded()
        }.disposed(by: &disposeBag)
    }

    // MARK: - Private methods

    /// Unfortunately the only easy way to update a running `CABasicAnimation`, is to restart it.
    /// Mutating a running animation throws an exception!
    private func restartAnimationIfNeeded() {
        guard isAnimatingSubject.value else { return }

        isAnimatingSubject.value = false
        isAnimatingSubject.value = true
    }
}

// MARK: - Helper

extension Array where Element == UIColor {

    /// Creates an infinite gradient out of the given colors.
    ///
    /// Therefore we'll reverse the colors and remove the first and last item
    /// to prevent duplicate values at the "inner edges" destroying the infinite look.
    ///
    /// E.g. for array of [.red, .yellow, .green]
    /// we will create    [.red, .yellow, .green, .yellow, .red, .yellow, .green]
    ///
    /// E.g. for array of [.red, .yellow, .green, .blue]
    /// we will create    [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]
    ///
    /// With the created array we can animate from left to right and restart the animation without a noticeable glitch.
    func infiniteGradientColors() -> [UIColor] {
        let reversedColors = reversed()
            .dropFirst()
            .dropLast()

        return self + reversedColors + self
    }
}
