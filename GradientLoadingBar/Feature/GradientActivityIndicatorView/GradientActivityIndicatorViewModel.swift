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
            // in order to simulate infinite animation.
            var frame = bounds
            frame.size.width *= 3

            gradientLayerSizeUpdateSubject.value = SizeUpdate(frame: frame,
                                                              fromValue: bounds.width * -2)
        }
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = gradientColors.infiniteLayerColors()
        }
    }

    /// The duration for the progress animation.
    ///
    ///  - Note: We explicitly have to pass this through the view-model in order to restart the animation when this value changes
    ///          while the loading bar is visible.
    var progressAnimationDuration = TimeInterval.GradientLoadingBar.progressDuration {
        didSet {
            gradientLayerAnimationDurationSubject.value = progressAnimationDuration
        }
    }

    // MARK: - Private properties

    // As our view is initially visible, we also have to start the progress animation initially.
    private let isAnimatingSubject = Variable(true)
    private let gradientLayerSizeUpdateSubject = Variable(SizeUpdate(frame: .zero, fromValue: 0))

    private let gradientLayerColorsSubject: Variable<[CGColor]>
    private let gradientLayerAnimationDurationSubject: Variable<TimeInterval>

    private var disposeBag = DisposeBag()

    // MARK: - Initializer

    init() {
        gradientLayerColorsSubject = Variable(gradientColors.infiniteLayerColors())
        gradientLayerAnimationDurationSubject = Variable(progressAnimationDuration)

        gradientLayerAnimationDuration.subscribe { [weak self] _, _ in
            self?.restartAnimationIfNeeded()
        }.disposed(by: &disposeBag)

        gradientLayerSizeUpdate.subscribe { [weak self] _, _ in
            self?.restartAnimationIfNeeded()
        }.disposed(by: &disposeBag)
    }

    // MARK: - Private methods

    /// Unfortunately the only easy way to update a running `CABasicAnimation`, is to restart it.
    /// Mutating a running animation throws an exception!!
    private func restartAnimationIfNeeded() {
        guard isAnimatingSubject.value else { return }

        isAnimatingSubject.value = false
        isAnimatingSubject.value = true
    }
}

// MARK: - Helperz

extension Array where Element == UIColor {
    ///
    ///
    func infiniteLayerColors() -> [CGColor] {
        let cgColors = map(\.cgColor)

        // Simulate infinite animation - Therefore we'll reverse the colors and remove the first and last item
        // to prevent duplicate values at the "inner edges" destroying the infinite look.
        //
        // E.g. for array of [.red, .yellow, .green]
        // we will create    [.red, .yellow, .green, .yellow, .red, .yellow, .green]
        //
        // E.g. for array of [.red, .yellow, .green, .blue]
        // we will create    [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]
        let reversedColors = cgColors.reversed()
            .dropFirst()
            .dropLast()

        return cgColors + reversedColors + cgColors
    }
}
