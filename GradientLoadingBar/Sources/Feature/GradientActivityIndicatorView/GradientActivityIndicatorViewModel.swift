//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Combine
import UIKit

/// This view model contains all logic related to the `GradientActivityIndicatorView`.
final class GradientActivityIndicatorViewModel {

    // MARK: - Public properties

    /// Observable state of the progress animation.
    var isAnimating: AnyPublisher<Bool, Never> {
        isAnimatingSubject.eraseToAnyPublisher()
    }

    /// Observable frame of the gradient layer.
    var gradientLayerSizeUpdate: AnyPublisher<SizeUpdate, Never> {
        boundsSubject
            .map { SizeUpdate(bounds: $0) }
            .eraseToAnyPublisher()
    }

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: AnyPublisher<[CGColor], Never> {
        gradientLayerColorsSubject
            .map { $0.infiniteGradientColors() }
            .map { $0.map(\.cgColor) }
            .eraseToAnyPublisher()
    }

    /// Observable duration of the animation of the gradient layer.
    var gradientLayerAnimationDuration: AnyPublisher<TimeInterval, Never> {
        gradientLayerAnimationDurationSubject.eraseToAnyPublisher()
    }

    /// Boolean flag, whether the view is currently hidden.
    var isHidden = false {
        didSet {
            isAnimatingSubject.value = !isHidden
        }
    }

    /// The bounds of the view.
    var bounds: CGRect {
        get { boundsSubject.value }
        set { boundsSubject.value = newValue }
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors: [UIColor] {
        get { gradientLayerColorsSubject.value }
        set { gradientLayerColorsSubject.value = newValue }
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
    private let isAnimatingSubject = CurrentValueSubject<Bool, Never>(true)
    private let boundsSubject = CurrentValueSubject<CGRect, Never>(.zero)

    private let gradientLayerColorsSubject = CurrentValueSubject<[UIColor], Never>(UIColor.GradientLoadingBar.gradientColors)
    private let gradientLayerAnimationDurationSubject = CurrentValueSubject<TimeInterval, Never>(TimeInterval.GradientLoadingBar.progressDuration)

    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Instance Lifecycle

    init() {
        gradientLayerAnimationDuration.sink { [weak self] _ in
            self?.restartAnimationIfNeeded()
        }.store(in: &subscriptions)

        gradientLayerSizeUpdate.sink { [weak self] _ in
            self?.restartAnimationIfNeeded()
        }.store(in: &subscriptions)
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

// MARK: - Supporting Types

extension GradientActivityIndicatorViewModel {

    /// - Note: The `fromValue` used on the `CABasicAnimation` is dependent on the `frame`,
    ///         therefore we always update these values together.
    struct SizeUpdate: Equatable {

        /// The frame of our gradient layer.
        /// This has to be three times the width of the parent bounds in order to apply the normal, reversed and
        /// again normal gradient colors to simulate the infinite animation.
        var frame: CGRect {
            var frame = bounds
            frame.size.width *= 3

            return frame
        }

        /// The value to start the animation from.
        var fromValue: CGFloat {
            bounds.width * -2
        }

        /// The boundaries of the superview.
        private let bounds: CGRect

        init(bounds: CGRect) {
            self.bounds = bounds
        }
    }
}

// MARK: - Helper

private extension Array where Element == UIColor {

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
