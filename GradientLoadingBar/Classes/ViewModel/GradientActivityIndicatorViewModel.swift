//
//  GradientActivityIndicatorViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

// MARK: - Types

/// Array of locations, used to position the gradient colors during the animation.
typealias ColorLocationRow = [NSNumber]

/// Array containing an array of locations, used to position the gradient colors during the animation:
/// - The outer array defines each animation step.
/// - The inner array defines the location of each gradient-color during this animation step.
typealias ColorLocationMatrix = [ColorLocationRow]

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
/// So first we have to create a single array of all colors used in the above states:
/// Therefore we'll duplicate the `gradientColors`, reverse them, and remove the first and last item of the reversed array in order to
/// prevent duplicate values at the "inner edges" destroying the infinite look. Afterwards we can append the `gradientColors` again.
///
/// Given the above `gradientColors` our corresponding `gradientLayerColors` will look like this:
/// `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
///
/// Now we can animate through all of the colors, by updating the `locations` property accordingly. Please have a look at the documentation
/// for the method `makeColorLocationMatrix(gradientColorsQuantity:gradientLayerColorsQuantity:)` for further details regarding the `locations`
/// property.
///
/// As the colors at the start are the same as at the end, we can loop the animation without visual artefacts.
final class GradientActivityIndicatorViewModel {
    // MARK: - Public properties

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: Observable<[CGColor]> {
        gradientLayerColorsSubject
    }

    /// Observable color locations for the gradient layer.
    ///
    /// - Note: In order to have a working animation we need to provide the initial gradient-locations,
    ///         which is the first row of our animation matrix.
    var colorLocationInitialRow: Observable<ColorLocationRow> {
        colorLocationInitialRowSubject
    }

    /// Observable color location matrix, used to position the gradient colors during the animation.
    /// - The outer array defines each animation step.
    /// - The inner array defines the location of each gradient-color during this animation step.
    var colorLocationMatrix: Observable<ColorLocationMatrix> {
        colorLocationMatrixSubject
    }

    /// Observable duration for the progress animation.
    var animationDuration: Observable<TimeInterval> {
        animationDurationSubject
    }

    /// Observable flag, whether we're currently animating the progress.
    var isAnimating: Observable<Bool> {
        isAnimatingSubject
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = makeGradientLayerColors()

            let gradientLocationMatrix = makeColorLocationMatrix()
            colorLocationInitialRowSubject.value = gradientLocationMatrix[0]
            colorLocationMatrixSubject.value = gradientLocationMatrix
        }
    }

    /// The duration for the progress animation.
    var progressAnimationDuration: TimeInterval {
        get {
            animationDurationSubject.value
        }
        set {
            animationDurationSubject.value = newValue
        }
    }

    /// Boolean flag whether the view is currently hidden.
    var isHidden = false {
        didSet {
            isAnimatingSubject.value = !isHidden
        }
    }

    // MARK: - Private properties

    private let gradientLayerColorsSubject: Variable<[CGColor]>
    private let colorLocationInitialRowSubject: Variable<ColorLocationRow>
    private let colorLocationMatrixSubject: Variable<ColorLocationMatrix>

    private let animationDurationSubject = Variable(TimeInterval.GradientLoadingBar.progressDuration)
    private let isAnimatingSubject = Variable(true)

    // MARK: - Initializer

    init() {
        let gradientLayerColors = Self.makeGradientLayerColors(from: gradientColors)
        let gradientLocationMatrix = Self.makeColorLocationMatrix(gradientColorsQuantity: gradientColors.count,
                                                                  gradientLayerColorsQuantity: gradientLayerColors.count)

        gradientLayerColorsSubject = Variable(gradientLayerColors)
        colorLocationInitialRowSubject = Variable(gradientLocationMatrix[0])
        colorLocationMatrixSubject = Variable(gradientLocationMatrix)
    }

    // MARK: - Private methods

    /// Forward calls to the static factory method `makeGradientLayerColors(from:)` by providing the required parameters.
    private func makeGradientLayerColors() -> [CGColor] {
        Self.makeGradientLayerColors(from: gradientColors)
    }

    /// Forward calls to the static factory method `makeColorLocationMatrix(gradientColorsQuantity:gradientLayerColorsQuantity:)`
    /// by providing the required parameters.
    private func makeColorLocationMatrix() -> ColorLocationMatrix {
        Self.makeColorLocationMatrix(gradientColorsQuantity: gradientColors.count,
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
    private static func makeColorLocationRow(index: Int,
                                             gradientColorsQuantity: Int,
                                             gradientLayerColorsQuantity: Int) -> ColorLocationRow {
        let startLocationsQuantity = gradientLayerColorsQuantity - gradientColorsQuantity - index
        let startLocations = [NSNumber](repeating: 0.0, count: startLocationsQuantity)

        // E.g. if we have `gradientColors = [.red, .yellow, .green, .blue]`
        // we need to position them as      `[ 0.0,  0.33,    0.66,   0.99]`.
        let increaseBy = 1.0 / Double(gradientColorsQuantity - 1)
        let range = 0 ..< gradientColorsQuantity
        let gradientLocations = range.reduce(into: ColorLocationRow(repeating: 0.0, count: gradientColorsQuantity)) { gradientLocations, col in
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
    private static func makeColorLocationMatrix(gradientColorsQuantity: Int,
                                                gradientLayerColorsQuantity: Int) -> ColorLocationMatrix {
        let matrixHeight = gradientLayerColorsQuantity - gradientColorsQuantity + 1
        let range = 0 ..< matrixHeight

        return range.reduce(into: ColorLocationMatrix(repeating: [], count: matrixHeight)) { gradientLocationMatrix, row in
            gradientLocationMatrix[row] = Self.makeColorLocationRow(index: row,
                                                                    gradientColorsQuantity: gradientColorsQuantity,
                                                                    gradientLayerColorsQuantity: gradientLayerColorsQuantity)
        }
    }
}
