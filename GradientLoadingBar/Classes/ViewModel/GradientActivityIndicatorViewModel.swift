//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

/// This view model contains all logic related to the `GradientActivityIndicatorView`.
final class GradientActivityIndicatorViewModel {
    // MARK: - Types

    /// State of the progress animation.
    enum ProgressAnimationState: Equatable {
        /// The progress animation is currently stopped.
        case none

        /// The progress animation is currently running with the given duration.
        case animating(duration: TimeInterval)
    }

    // MARK: - Public properties

    /// Observable state of the progress animation.
    var progressAnimationState: Observable<ProgressAnimationState> {
        return progressAnimationStateSubject.asObservable
    }

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: Observable<[CGColor]> {
        return gradientLayerColorsSubject.asObservable
    }

    /// Boolean flag, whether the view is currently hidden.
    var isHidden = false {
        didSet {
            if isHidden {
                progressAnimationStateSubject.value = .none
            } else {
                progressAnimationStateSubject.value = .animating(duration: progressAnimationDuration)
            }
        }
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = makeGradientLayerColors()
        }
    }

    /// The duration for the progress animation.
    var progressAnimationDuration = TimeInterval.GradientLoadingBar.progressDuration

    // MARK: - Private properties

    private let progressAnimationStateSubject: Variable<ProgressAnimationState>

    private let gradientLayerColorsSubject: Variable<[CGColor]>

    // MARK: - Initializer

    init() {
        // As the view is visible initially, we need to set-up the observables accordingly.
        progressAnimationStateSubject = Variable(.animating(duration: progressAnimationDuration))

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
}
