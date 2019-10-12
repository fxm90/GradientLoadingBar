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

/// Array containing an array of locations, that are used to position the gradient colors during the animation:
/// - The outer array defines each animation step.
/// - The inner array defines the location of each gradient-color during this animation step.
typealias GradientLocationAnimationMatrix = [[NSNumber]]

/// Classes implementing this delegate protocol will get notified about animation changes.
///
/// - Note: Unfortunately `LightweightObservable` doesn't support signals (yet), therefore we fallback to a delegate pattern
///         for the signal to start / stop the animation.
protocol GradientActivityIndicatorViewModelDelegate: AnyObject {
    /// Informs the delegate to start animating the locations of the gradient colors.
    ///
    /// - Parameters:
    ///   - values: Array containing an array of locations, that are used to position the gradient colors.
    ///   - duration: The entire duration to animate all locations with.
    func startAnimatingLocations(values: GradientLocationAnimationMatrix, duration: TimeInterval)

    /// Informs the delegate to stop animating the locations of the gradient colors.
    func stopAnimatingLocations()
}

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
/// So first thing we're gonna do is to create a single array of all colors used in the above states.
/// Therefore we'll duplicate the `gradientColors`, reverse them, and remove the first and last item of the reversed array in order to
/// prevent duplicate values at the "inner edges" destroying the infinite look. Afterwards we can append the `gradientColors` again.
///
/// Given the above `gradientColors` our corresponding `gradientLayerColors` will look like this:
/// `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
///
/// Now we can animate through all of the colors, by updating the `locations` property accordingly. Please have a look at the documentation
/// for the method `makeGradientLocationAnimationMatrix()` for further details regarding the `locations` property.
///
/// As the colors at the start are the same as at the end, we can loop the animation without visual artefacts.
final class GradientActivityIndicatorViewModel {
    // MARK: - Public properties

    /// Observable color array for the gradient layer (of type `CGColor`).
    var gradientLayerColors: Observable<[CGColor]> {
        gradientLayerColorsSubject.asObservable
    }

    /// The (initial) color locations for the gradient layer.
    var gradientLayerLocations: Observable<[NSNumber]> {
        gradientLayerLocationsSubject.asObservable
    }

    /// Color array used for the gradient (of type `UIColor`).
    var gradientColors = UIColor.GradientLoadingBar.gradientColors {
        didSet {
            gradientLayerColorsSubject.value = makeGradientLayerColors()
            gradientLayerLocationsSubject.value = makeGradientLocationAnimationMatrixInitialRow()
        }
    }

    /// The duration for the progress animation.
    var progressAnimationDuration = TimeInterval.GradientLoadingBar.progressDuration

    /// Boolean flag, whether the view is currently hidden.
    var isHidden = false {
        didSet {
            if isHidden {
                stopAnimatingLocations()
            } else {
                startAnimatingLocations()
            }
        }
    }

    weak var delegate: GradientActivityIndicatorViewModelDelegate?

    // MARK: - Private properties

    private let gradientLayerColorsSubject: Variable<[CGColor]> = Variable([])

    private let gradientLayerLocationsSubject: Variable<[NSNumber]> = Variable([])

    // MARK: - Initializer

    init() {
        gradientLayerColorsSubject.value = makeGradientLayerColors()
        gradientLayerLocationsSubject.value = makeGradientLocationAnimationMatrixInitialRow()
    }

    // MARK: - Public methods

    func startAnimationIfNeeded() {
        guard !isHidden else { return }

        startAnimatingLocations()
    }

    // MARK: - Private methods

    /// Generates the colors used on the gradient-layer.
    ///
    /// Example for   `gradientColors      = [.red, .yellow, .green, .blue]`
    /// and therefore `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
    private func makeGradientLayerColors() -> [CGColor] {
        // Simulate infinite animation - Therefore we'll reverse the colors and remove the first and last item
        // to prevent duplicate values at the "inner edges" destroying the infinite look.
        let reversedColors = gradientColors
            .reversed()
            .dropFirst()
            .dropLast()

        let infiniteGradientColors = gradientColors + reversedColors + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }

    /// Generates the locations for the gradient colors,
    /// by placing them equally between zero and one.
    ///
    /// E.g. if we have `gradientColors = [.red, .yellow, .green, .blue]`
    /// we need to position them as      `[ 0.0,  0.33,    0.66,   0.99]`.
    private func makeGradientLocations() -> [NSNumber] {
        let gradientColorsQuantity = gradientColors.count
        let increaseBy = 1.0 / Double(gradientColorsQuantity - 1)

        var percentageLocations = [NSNumber](repeating: 1.0, count: gradientColorsQuantity)
        for index in 0 ..< gradientColorsQuantity {
            let value = increaseBy * Double(index)
            percentageLocations[index] = NSNumber(value: value)
        }

        return percentageLocations
    }

    /// Generates the first row of the `locations` matrix for animating the current `gradientColors`.
    /// We use this method to initialize the corresponding property, as the animation starts from these location values.
    ///
    /// Example for   `gradientColors      = [.red, .yellow, .green, .blue]`
    /// and therefore `gradientLayerColors = [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]`
    /// ```
    ///  gradientLayerColors | .red | .yellow | .green | .blue | .green | .yellow | .red | .yellow | .green | .blue
    ///  initialLocations    | 0    | 0       | 0      | 0     | 0      | 0       | 0    | 0.33    | 0.66   | 1
    /// ```
    private func makeGradientLocationAnimationMatrixInitialRow() -> [NSNumber] {
        let gradientColorsQuantity = gradientColors.count
        let gradientLayerColorsQuantity = gradientLayerColors.value.count

        let startLocationsQuantity = gradientLayerColorsQuantity - gradientColorsQuantity
        let startLocations = [NSNumber](repeating: 0.0, count: startLocationsQuantity)

        let gradientLocations = makeGradientLocations()
        return startLocations + gradientLocations
    }

    /// Generates the `locations` matrix for animating the current `gradientColors`.
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
    private func makeGradientLocationAnimationMatrix() -> GradientLocationAnimationMatrix {
        let gradientColorsQuantity = gradientColors.count
        let gradientLayerColorsQuantity = gradientLayerColors.value.count

        let gradientLocations = makeGradientLocations()

        // As the matrix is zero based, we have to increase the value by one here.
        let matrixHeight = gradientLayerColorsQuantity - gradientColorsQuantity + 1

        var locationsMatrix = GradientLocationAnimationMatrix(repeating: [], count: matrixHeight)
        for index in 0 ..< matrixHeight {
            let startLocationsQuantity = gradientLayerColorsQuantity - gradientColorsQuantity - index
            let startLocations = [NSNumber](repeating: 0.0, count: startLocationsQuantity)

            let endLocationsQuantity = index
            let endLocations = [NSNumber](repeating: 1.0, count: endLocationsQuantity)

            locationsMatrix[index] = startLocations + gradientLocations + endLocations
        }

        return locationsMatrix
    }

    private func startAnimatingLocations() {
        let gradientLocationAnimationMatrix = makeGradientLocationAnimationMatrix()

        delegate?.startAnimatingLocations(values: gradientLocationAnimationMatrix,
                                          duration: progressAnimationDuration)
    }

    private func stopAnimatingLocations() {
        delegate?.stopAnimatingLocations()
    }
}
