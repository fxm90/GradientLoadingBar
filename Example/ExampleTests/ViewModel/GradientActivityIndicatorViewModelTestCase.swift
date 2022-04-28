//
//  GradientActivityIndicatorViewModelTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

@testable import GradientLoadingBar

// swiftlint:disable:next type_name
final class GradientActivityIndicatorViewModelTestCase: XCTestCase {

    // MARK: - Private properties

    private var viewModel: GradientActivityIndicatorViewModel!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        viewModel = GradientActivityIndicatorViewModel()
    }

    override func tearDown() {
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Test initializer

    func test_initializer_shouldSetGradientLayerColors_toCorrectValue() {
        let expectedGradientLayerColors = makeGradientLayerColors()
        XCTAssertEqual(viewModel.gradientLayerColors.value, expectedGradientLayerColors)
    }

    func test_initializer_shouldSetColorLocationMatrix_toCorrectValue() throws {
        let receivedColorLocationMatrix = try XCTUnwrap(viewModel.colorLocationMatrix.value)
        let expectedColorLocationMatrix = makeColorLocationMatrix()

        // Unfortunately there is no easier way comparing an array of type `NSNumber` / `Double` with a given accuracy.
        XCTAssertEqual(receivedColorLocationMatrix.count, expectedColorLocationMatrix.count)

        for (receivedColorLocationRow, expectedColorLocationRow) in zip(receivedColorLocationMatrix, expectedColorLocationMatrix) {
            XCTAssertEqual(receivedColorLocationRow.count, expectedColorLocationRow.count)

            for (receivedColorLocation, expectedColorLocation) in zip(receivedColorLocationRow, expectedColorLocationRow) {
                XCTAssertEqual(receivedColorLocation.doubleValue, expectedColorLocation.doubleValue, accuracy: .ulpOfOne)
            }
        }
    }

    func test_initializer_shouldSetAnimationDuration_toStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.animationDuration.value, TimeInterval.GradientLoadingBar.progressDuration)
    }

    func test_initializer_shouldSetIsAnimating_toTrue() throws {
        XCTAssertTrue(
            try XCTUnwrap(viewModel.isAnimating.value)
        )
    }

    func test_initializer_shouldSetGradientColors_toStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.gradientColors, UIColor.GradientLoadingBar.gradientColors)
    }

    func test_initializer_shouldSetProgressAnimationDuration_toStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.progressAnimationDuration, TimeInterval.GradientLoadingBar.progressDuration)
    }

    func test_initializer_ShouldSetIsHidden_toFalse() {
        XCTAssertFalse(viewModel.isHidden)
    }

    // MARK: - Test property `gradientColors`

    func test_settingGradientColors_shouldUpdateGradientLayerColorsObservable() {
        // Given
        let gradientColors: [UIColor] = [.red, .yellow, .green]

        // When
        viewModel.gradientColors = gradientColors

        // Then
        //
        // `gradientColors      = [.red, .yellow, .green]`
        // `gradientLayerColors = [.red, .yellow, .green, .yellow, .red, .yellow, .green]`
        //
        let expectedGradientColors: [UIColor] = [.red, .yellow, .green, .yellow, .red, .yellow, .green]
        let expectedGradientLayerColors = expectedGradientColors.map(\.cgColor)

        XCTAssertEqual(viewModel.gradientLayerColors.value, expectedGradientLayerColors)
    }

    func test_settingGradientColors_shouldUpdateColorLocationMatrixObservable() {
        // Given
        let gradientColors: [UIColor] = [.red, .yellow, .green]

        // When
        viewModel.gradientColors = gradientColors

        // Then
        //
        // `gradientColors      = [.red, .yellow, .green]`
        // `gradientLayerColors = [.red, .yellow, .green, .yellow, .red, .yellow, .green]`
        //
        //  i | .red | .yellow | .green | .yellow | .red | .yellow | .green
        //  0 | 0    | 0       | 0      | 0       | 0    | 0.5     | 1
        //  1 | 0    | 0       | 0      | 0       | 0.5  | 1       | 1
        //  2 | 0    | 0       | 0      | 0.5     | 1    | 1       | 1
        //  3 | 0    | 0       | 0.5    | 1       | 1    | 1       | 1
        //  4 | 0    | 0.5     | 1      | 1       | 1    | 1       | 1
        //
        let colorLocationMatrix = [
            [0, 0, 0, 0, 0, 0.5, 1],
            [0, 0, 0, 0, 0.5, 1, 1],
            [0, 0, 0, 0.5, 1, 1, 1],
            [0, 0, 0.5, 1, 1, 1, 1],
            [0, 0.5, 1, 1, 1, 1, 1],
        ]

        let expectedColorLocationMatrix = colorLocationMatrix.map {
            $0.map { NSNumber(value: $0) }
        }

        XCTAssertEqual(viewModel.colorLocationMatrix.value, expectedColorLocationMatrix)
    }

    // MARK: - Test property `progressAnimationDuration`

    func test_settingProgressAnimationDuration_shouldUpdateAnimationDurationObservable() {
        // Given
        let progressAnimationDuration: TimeInterval = 123

        // When
        viewModel.progressAnimationDuration = progressAnimationDuration

        // Then
        XCTAssertEqual(viewModel.animationDuration.value, progressAnimationDuration)
    }

    // MARK: - Test property `isHidden`

    func test_settingIsHiddenToTrue_shouldSetIsAnimatingToFalse() throws {
        // When
        viewModel.isHidden = true

        // Then
        XCTAssertFalse(
            try XCTUnwrap(viewModel.isAnimating.value)
        )
    }

    func test_settingIsHiddenToFalse_shouldSetIsAnimatingToTrue() throws {
        // When
        viewModel.isHidden = false

        // Then
        XCTAssertTrue(
            try XCTUnwrap(viewModel.isAnimating.value)
        )
    }
}

// MARK: - Helper

extension GradientActivityIndicatorViewModelTestCase {

    private func makeGradientLayerColors() -> [CGColor] {
        let gradientColors = [
            #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1),
        ]

        XCTAssertEqual(gradientColors, UIColor.GradientLoadingBar.gradientColors,
                       "Precondition failed – The given gradient colors do not match the current color constant!")

        // swiftlint:disable:next identifier_name
        let reversedGradientColorsWithoutFirstAndLastValue = [
            #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1),
        ]

        let infiniteGradientColors = gradientColors + reversedGradientColorsWithoutFirstAndLastValue + gradientColors
        return infiniteGradientColors.map(\.cgColor)
    }

    private func makeColorLocationInitialRow() -> ColorLocationRow {
        let gradientLocations = [0, 0.2, 0.4, 0.6, 0.8, 1]

        XCTAssertEqual(gradientLocations.count, UIColor.GradientLoadingBar.gradientColors.count,
                       "Precondition failed – The given gradient locations do not match for the current color constant!")

        // The current constant has 6 value and therefore we expect 16 gradient layer colors in total.
        // Ergo we have to fill the first 10 values with "0", before adding the `gradientLocations`.
        //
        // .green | .malibu | .azure | .curious | .violet | .red | .violet | .curious | .azure | .malibu | .green | .malibu | .azure | .curious | .violet | .red
        // 0      | 0       | 0      | 0        | 0       | 0    | 0       | 0        | 0      | 0       | 0      | 0.2     | 0.4    | 0.6      | 0.8     | 1
        //
        // swiftlint:disable:next identifier_name
        let gradientLocationAnimationMatrixInitialRow = Array(repeating: 0.0, count: 10) + gradientLocations

        return gradientLocationAnimationMatrixInitialRow.map {
            NSNumber(value: $0)
        }
    }

    private func makeColorLocationMatrix() -> ColorLocationMatrix {
        let gradientLocations = [0, 0.2, 0.4, 0.6, 0.8, 1]

        XCTAssertEqual(gradientLocations.count, UIColor.GradientLoadingBar.gradientColors.count,
                       "Precondition failed – The given gradient locations do not match for the current color constant!")

        // The current constant has 6 value and therefore we expect 16 gradient layer colors in total.
        // Ergo we have to fill the first 10 values with "0", before adding the `gradientLocations`.
        //
        // .green | .malibu | .azure | .curious | .violet | .red | .violet | .curious | .azure | .malibu | .green | .malibu | .azure | .curious | .violet | .red
        // 0      | 0       | 0      | 0        | 0       | 0    | 0       | 0        | 0      | 0       | 0      | 0.2     | 0.4    | 0.6      | 0.8     | 1
        // ...
        // 0      | 0       | 0      | 0        | 0       | 0    | 0.2     | 0.4      | 0.6    | 0.8     | 1      | 1       | 1      | 1        | 1       | 1
        // ...
        // 0      | 0.2     | 0.4    | 0.6      | 0.8     | 1    | 1       | 1        | 1      | 1       | 1      | 1       | 1      | 1        | 1       | 1
        //
        let colorLocationMatrix = [
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1],
            [0, 0, 0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1],
            [0, 0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1, 1],
            [0, 0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1, 1, 1],
            [0, 0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1, 1, 1, 1],
            [0, 0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [0, 0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [0, 0.2, 0.4, 0.6, 0.8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        ]

        return colorLocationMatrix.map {
            $0.map { NSNumber(value: $0) }
        }
    }
}
