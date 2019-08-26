//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

class GradientActivityIndicatorViewModel {
    // MARK: - Types

    ///
    enum AnimationState: Equatable {
        case none
        case animating(duration: TimeInterval)
    }

    // MARK: - Public properties

    ///
    var animationState: Observable<AnimationState> {
        return animationStateSubject.asObservable
    }

    ///
    var infinteGradientColors: Observable<[CGColor]> {
        return infinteGradientColorsSubject.asObservable
    }

    ///
    var isHidden = false {
        didSet {
            if isHidden {
                animationStateSubject.value = .none
            } else {
                animationStateSubject.value = .animating(duration: progressAnimationDuration)
            }
        }
    }

    /// Colors used for the gradient.
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            infinteGradientColorsSubject.value = makeInfiniteGradientColors()
        }
    }

    /// Duration for the progress animation.
    var progressAnimationDuration = TimeInterval.GradientLoadingBar.progressDuration

    // MARK: - Private properties

    private let infinteGradientColorsSubject: Variable<[CGColor]>

    private let animationStateSubject: Variable<AnimationState>

    // MARK: - Initializer

    init() {
        // As the view is visible initially, we need to set-up the observables accordingly.
        animationStateSubject = Variable(.animating(duration: progressAnimationDuration))

        // Small workaround as calls to `self.makeInfiniteGradientColors()` aren't allowed before all properties have been initialized.
        infinteGradientColorsSubject = Variable([])
        infinteGradientColorsSubject.value = makeInfiniteGradientColors()
    }

    // MARK: - Private methods

    /// Simulate infinte animation - Therefore we'll reverse the colors and remove the first and last item
    /// to prevent duplicate values at the "inner edges" destroying the infinite look.
    private func makeInfiniteGradientColors() -> [CGColor] {
        let reversedColors = gradientColors
            .reversed()
            .dropFirst()
            .dropLast()

        let infiniteGradientColors = gradientColors + reversedColors + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }
}
