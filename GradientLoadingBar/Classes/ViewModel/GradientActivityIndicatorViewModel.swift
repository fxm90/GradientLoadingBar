//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

// MARK: - Types

/// Array of locations, used to position the gradient colors during the animation.
typealias GradientLocationRow = [NSNumber]

/// Array containing an array of locations, used to position the gradient colors during the animation:
/// - The outer array defines each animation step.
/// - The inner array defines the location of each gradient-color during this animation step.
typealias GradientLocationMatrix = [GradientLocationRow]

/// This view model contains all logic related to the `GradientActivityIndicatorView` and the corresponding animation.
///
/// # How to create the infinite animation
/// Example for `gradientColors = [.red, .yellow, .green, .blue]`
///
/// Given the above `gradientColors` we can define three animation states:
///  - Visible colors at the **start** of the animation:  `[.red, .yellow, .green, .blue]`
///  - Visible colors in the **middle** of the animation: `[.blue, .green, .yellow, .red]` (inverted `gradientColors`)
///  - Visible colors at the **end** of the animation:    `[.red, .yellow, .green, .blue]` (same as start `gradientColors`)
///
/// So first thing we have to do, is to create a single array of all colors used in the above states.
/// Therefore we'll duplicate the `gradientColors`, reverse them, and remove the first and last item of the reversed array in order to
/// prevent duplicate values at the "inner edges" destroying the infinite look. Afterwards we can append the `gradientColors` again.
///
/// Given the above `gradientColors` our corresponding `gradientLayerColors` will look like this:
/// `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
///
/// Now we can animate through all of the colors, by updating the `locations` property accordingly. Please have a look at the documentation
/// for the method `makeGradientLocationMatrix(gradientColorsQuantity:gradientLayerColorsQuantity:)` for further details regarding the `locations`
/// property.
///
/// As the colors at the start are the same as at the end, we can loop the animation without visual artefacts.
final class GradientActivityIndicatorViewModel {
    // MARK: - Types

    enum AnimationState: Equatable {
        /// Start animating the locations of the gradient colors.
        ///
        /// - Parameters:
        ///   - values: Array containing an array of locations, used to position the gradient colors during the animation.
        ///   - duration: The entire duration to animate all locations with.
        case active(values: GradientLocationMatrix, duration: TimeInterval)

        /// Stop animating the locations of the gradient colors.
        case inactive
    }

    // MARK: - Public properties

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: Observable<[CGColor]> {
        gradientLayerColorsSubject
    }

    /// Observable color locations for the gradient layer.
    var gradientLayerLocations: Observable<GradientLocationRow> {
        gradientLayerLocationsSubject
    }

    /// Observable current animation state.
    var animationState: Observable<AnimationState> {
        animationStateSubject
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = makeGradientLayerColors()

            // In order to have a working animation we need to provide the initial gradient-locations,
            // which is the first row of our animation matrix.
            gradientLayerLocationsSubject.value = makeGradientLocationRow(index: 0)
        }
    }

    /// The duration for the progress animation.
    var progressAnimationDuration = TimeInterval.GradientLoadingBar.progressDuration

    /// Boolean flag whether the view is currently hidden.
    var isHidden = false {
        didSet {
            if isHidden {
                animationStateSubject.value = .inactive
            } else {
                animationStateSubject.value = .active(values: makeGradientLocationMatrix(),
                                                      duration: progressAnimationDuration)
            }
        }
    }

    // MARK: - Private properties

    private let gradientLayerColorsSubject: Variable<[CGColor]>
    private let gradientLayerLocationsSubject: Variable<[NSNumber]>
    private let animationStateSubject: Variable<AnimationState>

    // MARK: - Initializer

    init() {
        let gradientLayerColors = Self.makeGradientLayerColors(from: gradientColors)
        let gradientLocationMatrix = Self.makeGradientLocationMatrix(gradientColorsQuantity: gradientColors.count,
                                                                     gradientLayerColorsQuantity: gradientLayerColors.count)

        gradientLayerColorsSubject = Variable(gradientLayerColors)

        // In order to have a working animation we need to provide the initial gradient-locations,
        // which is the first row of our animation matrix.
        gradientLayerLocationsSubject = Variable(gradientLocationMatrix[0])

        // As the view is visible initially we already have to start the animation here.
        animationStateSubject = Variable(.active(values: gradientLocationMatrix,
                                                 duration: progressAnimationDuration))
    }

    // MARK: - Private methods

    /// Forward calls to the static factory method `makeGradientLayerColors(from:)` by providing the required parameters.
    private func makeGradientLayerColors() -> [CGColor] {
        Self.makeGradientLayerColors(from: gradientColors)
    }

    /// Forward calls to the static factory method `makeGradientLocationRow(index:gradientColorsQuantity:gradientLayerColorsQuantity:)`
    /// by providing the required parameters.
    private func makeGradientLocationRow(index: Int) -> GradientLocationRow {
        Self.makeGradientLocationRow(index: index,
                                     gradientColorsQuantity: gradientColors.count,
                                     gradientLayerColorsQuantity: gradientLayerColorsSubject.value.count)
    }

    /// Forward calls to the static factory method `makeGradientLocationMatrix(gradientColorsQuantity:gradientLayerColorsQuantity:)`
    /// by providing the required parameters.
    private func makeGradientLocationMatrix() -> GradientLocationMatrix {
        Self.makeGradientLocationMatrix(gradientColorsQuantity: gradientColors.count,
                                        gradientLayerColorsQuantity: gradientLayerColorsSubject.value.count)
    }

    /// Generates the colors used on the gradient-layer.
    ///
    /// Example for   `gradientColors      = [.red, .yellow, .green, .blue]`
    /// and therefore `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
    ///
    /// - Note: Declared `static` so we can call this method from the initializer, before `self` is available.
    private static func makeGradientLayerColors(from gradientColors: [UIColor]) -> [CGColor] {
        // Simulate infinite animation - Therefore we'll reverse the colors and remove the first and last item
        // to prevent duplicate values at the "inner edges" destroying the infinite look.
        let reversedColors = gradientColors
            .reversed()
            .dropFirst()
            .dropLast()

        let infiniteGradientColors = gradientColors + reversedColors + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }

    /// Generates a single row for the locations-matrix used for animating the current `gradientColors`.
    ///
    /// Example for   `index               = 0`
    ///               `gradientColors      = [.red, .yellow, .green, .blue]`
    /// and therefore `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
    /// ```
    ///  gradientLayerColors | .red | .yellow | .green | .blue | .green | .yellow | .red | .yellow | .green | .blue
    ///  gradientLocationRow | 0    | 0       | 0      | 0     | 0      | 0       | 0    | 0.33    | 0.66   | 1
    /// ```
    ///
    /// - Note: Declared `static` so we can call this method from the initializer, before `self` is available.
    private static func makeGradientLocationRow(index: Int,
                                                gradientColorsQuantity: Int,
                                                gradientLayerColorsQuantity: Int) -> GradientLocationRow {
        let startLocationsQuantity = gradientLayerColorsQuantity - gradientColorsQuantity - index
        let startLocations = [NSNumber](repeating: 0.0, count: startLocationsQuantity)

        // E.g. if we have `gradientColors = [.red, .yellow, .green, .blue]`
        // we need to position them as      `[ 0.0,  0.33,    0.66,   0.99]`.
        let increaseBy = 1.0 / Double(gradientColorsQuantity - 1)
        let range = 0 ..< gradientColorsQuantity
        let gradientLocations = range.reduce(into: GradientLocationRow(repeating: 1.0, count: gradientColorsQuantity)) { gradientLocations, col in
            let value = Double(col) * increaseBy
            gradientLocations[col] = value as NSNumber
        }

        let endLocationsQuantity = index
        let endLocations = [NSNumber](repeating: 1.0, count: endLocationsQuantity)

        return startLocations + gradientLocations + endLocations
    }

    /// Generates the locations-matrix used for animating the current `gradientColors`.
    ///
    /// Example for   `gradientColors      = [.red, .yellow, .green, .blue]`
    /// and therefore `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
    /// ```
    ///  i | .red | .yellow | .green | .blue | .green | .yellow | .red | .yellow | .green | .blue
    ///  0 | 0    | 0       | 0      | 0     | 0      | 0       | 0    | 0.33    | 0.66   | 1
    ///  1 | 0    | 0       | 0      | 0     | 0      | 0       | 0.33 | 0.66    | 1      | 1
    ///  2 | 0    | 0       | 0      | 0     | 0      | 0.33    | 0.66 | 1       | 1      | 1
    ///  3 | 0    | 0       | 0      | 0     | 0.33   | 0.66    | 1    | 1       | 1      | 1
    ///  4 | 0    | 0       | 0      | 0.33  | 0.66   | 1       | 1    | 1       | 1      | 1
    ///  5 | 0    | 0       | 0.33   | 0.66  | 1      | 1       | 1    | 1       | 1      | 1
    ///  6 | 0    | 0.33    | 0.66   | 1     | 1      | 1       | 1    | 1       | 1      | 1
    /// ```
    ///
    /// - Note: Declared `static` so we can call this method from the initializer, before `self` is available.
    private static func makeGradientLocationMatrix(gradientColorsQuantity: Int,
                                                   gradientLayerColorsQuantity: Int) -> GradientLocationMatrix {
        let matrixHeight = gradientLayerColorsQuantity - gradientColorsQuantity + 1
        let range = 0 ..< matrixHeight

        return range.reduce(into: GradientLocationMatrix(repeating: [], count: matrixHeight)) { gradientLocationMatrix, row in
            gradientLocationMatrix[row] = Self.makeGradientLocationRow(index: row,
                                                                       gradientColorsQuantity: gradientColorsQuantity,
                                                                       gradientLayerColorsQuantity: gradientLayerColorsQuantity)
        }
    }
}
