//
//  GradientActivityIndicatorViewModelTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import LightweightObservable

@testable import GradientLoadingBar

// swiftlint:disable:next type_name
class GradientActivityIndicatorViewModelTestCase: XCTestCase {
    // MARK: - Private properties

    private var delegateMock: GradientActivityIndicatorViewModelDelegateMock!
    private var viewModel: GradientActivityIndicatorViewModel!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        delegateMock = GradientActivityIndicatorViewModelDelegateMock()

        viewModel = GradientActivityIndicatorViewModel()
        viewModel.delegate = delegateMock
    }

    override func tearDown() {
        viewModel = nil
        delegateMock = nil

        super.tearDown()
    }

    // MARK: - Test initializer

    func testInitializerShouldSetGradientLayerColorsToCorrectValue() {
        let expectedGradientLayerColors = makeGradientLayerColors()
        XCTAssertEqual(viewModel.gradientLayerColors.value, expectedGradientLayerColors)
    }

    func testInitializerShouldSetGradientLayerLocationsToCorrectValue() {
        let receivedGradientLayerLocations = viewModel.gradientLayerLocations.value
        let expectedGradientLayerLocations = makeGradientLocationAnimationMatrixInitialRow()

        // Unfortunately there is no easier way comparing an array of type `NSNumber` / `Double` with a given accuracy.
        XCTAssertEqual(receivedGradientLayerLocations.count, expectedGradientLayerLocations.count)

        for (receivedLocation, expectedLocation) in zip(receivedGradientLayerLocations, expectedGradientLayerLocations) {
            XCTAssertEqual(receivedLocation.doubleValue, expectedLocation.doubleValue, accuracy: Double.ulpOfOne)
        }
    }

    func testInitializerShouldSetGradientColorsToStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.gradientColors, UIColor.GradientLoadingBar.gradientColors)
    }

    func testInitializerShouldSetProgressAnimationDurationToStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.progressAnimationDuration, TimeInterval.GradientLoadingBar.progressDuration)
    }

    func testInitializerShouldSetIsHiddenToFalse() {
        XCTAssertFalse(viewModel.isHidden)
    }

    // MARK: - Test property `gradientColors`

    func testSettingGradientColorsShouldUpdateGradientLayerColorsObservable() {
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
        let expectedGradientLayerColors = expectedGradientColors.map { $0.cgColor }

        XCTAssertEqual(viewModel.gradientLayerColors.value, expectedGradientLayerColors)
    }

    func testSettingGradientColorsShouldUpdateGradientLayerLocationsObservable() {
        // Given
        let gradientColors: [UIColor] = [.red, .yellow, .green]

        // When
        viewModel.gradientColors = gradientColors

        // Then
        //
        // `gradientColors      = [.red, .yellow, .green]`
        // `gradientLayerColors = [.red, .yellow, .green, .yellow, .red, .yellow, .green]`
        //
        //  gradientLayerColors | .red | .yellow | .green | .green | .yellow | .red | .yellow | .green
        //  initialLocations    | 0    | 0       | 0      | 0      | 0       | 0    | 0.5     | 1
        //
        let expectedGradientLocations = [0, 0, 0, 0, 0, 0.5, 1]
        let expectedGradientLayerLocations = expectedGradientLocations.map { NSNumber(value: $0) }

        XCTAssertEqual(viewModel.gradientLayerLocations.value, expectedGradientLayerLocations)
    }

    // MARK: - Test property `isHidden`

    func testSettingIsHiddenToTrueShouldInformDelegateToStopAnimatingLocations() {
        // When
        viewModel.isHidden = true

        // Then
        XCTAssertEqual(delegateMock.invokedMethod, .stopAnimatingLocations)
    }

    func testSettingIsHiddenToFalseShouldInformDelegateToStartAnimatingLocations() {
        // Given

        // In order to simplify the matrix, we're gonna update the `gradientColors` first.
        let gradientColors: [UIColor] = [.red, .yellow, .green]
        viewModel.gradientColors = gradientColors

        XCTAssertNil(delegateMock.invokedMethod,
                     "Precondition failed – Expected delegate not to be informed at this point!")

        // When
        viewModel.isHidden = false

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
        let gradientLocationsMatrix = [
            [0, 0, 0, 0, 0, 0.5, 1],
            [0, 0, 0, 0, 0.5, 1, 1],
            [0, 0, 0, 0.5, 1, 1, 1],
            [0, 0, 0.5, 1, 1, 1, 1],
            [0, 0.5, 1, 1, 1, 1, 1]
        ]

        let expectedValues = gradientLocationsMatrix.map {
            $0.map { NSNumber(value: $0) }
        }

        XCTAssertEqual(delegateMock.invokedMethod, .startAnimatingLocations(values: expectedValues,
                                                                            duration: viewModel.progressAnimationDuration))
    }

    // MARK: - Test method `startAnimationIfNeeded()`

    func testStartAnimationIfNeededShouldNotInformDelegateAsViewIsHidden() {
        // Given

        // As setting the property `isHidden` is also calling the delegate, we have to reset it afterwards.
        viewModel.isHidden = true
        delegateMock.reset()

        // When
        viewModel.startAnimationIfNeeded()

        // Then
        XCTAssertNil(delegateMock.invokedMethod)
    }

    func testStartAnimationIfNeededShouldInformDelegateToStartAnimatingLocations() {
        // Given

        // As setting the property `isHidden` is also calling the delegate, we have to reset it afterwards.
        viewModel.isHidden = false
        delegateMock.reset()

        // In order to simplify the matrix, we're gonna update the `gradientColors` first.
        let gradientColors: [UIColor] = [.red, .yellow, .green]
        viewModel.gradientColors = gradientColors

        XCTAssertNil(delegateMock.invokedMethod,
                     "Precondition failed – Expected delegate not to be informed at this point!")

        // When
        viewModel.startAnimationIfNeeded()

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
        let gradientLocationsMatrix = [
            [0, 0, 0, 0, 0, 0.5, 1],
            [0, 0, 0, 0, 0.5, 1, 1],
            [0, 0, 0, 0.5, 1, 1, 1],
            [0, 0, 0.5, 1, 1, 1, 1],
            [0, 0.5, 1, 1, 1, 1, 1]
        ]

        let expectedValues = gradientLocationsMatrix.map {
            $0.map { NSNumber(value: $0) }
        }

        XCTAssertEqual(delegateMock.invokedMethod, .startAnimatingLocations(values: expectedValues,
                                                                            duration: viewModel.progressAnimationDuration))
    }
}

// MARK: - Helpers

extension GradientActivityIndicatorViewModelTestCase {
    private func makeGradientLayerColors() -> [CGColor] {
        let gradientColors = [
            #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)
        ]

        XCTAssertEqual(gradientColors, UIColor.GradientLoadingBar.gradientColors,
                       "Precondition failed – The given gradient colors do not match the current color constant!")

        // swiftlint:disable:next identifier_name
        let reversedGradientColorsWithoutFirstAndLastValue = [
            #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1)
        ]

        let infiniteGradientColors = gradientColors + reversedGradientColorsWithoutFirstAndLastValue + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }

    private func makeGradientLocations() -> [NSNumber] {
        let gradientLocations = [0, 0.2, 0.4, 0.6, 0.8, 1]

        XCTAssertEqual(gradientLocations.count, UIColor.GradientLoadingBar.gradientColors.count,
                       "Precondition failed – The given gradient locations do not match for the current color constant!")

        return gradientLocations.map { NSNumber(value: $0) }
    }

    private func makeGradientLocationAnimationMatrixInitialRow() -> [NSNumber] {
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
        let gradientLocationAnimationMatrixInitialRow = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0] + gradientLocations

        return gradientLocationAnimationMatrixInitialRow.map { NSNumber(value: $0) }
    }
}

// MARK: - Mocks

// swiftlint:disable:next type_name
private class GradientActivityIndicatorViewModelDelegateMock: GradientActivityIndicatorViewModelDelegate {
    // MARK: - Types

    enum DelegateMethod: Equatable {
        case startAnimatingLocations(values: GradientLocationAnimationMatrix, duration: TimeInterval)
        case stopAnimatingLocations
    }

    // MARK: - Public properties

    private(set) var invokedMethod: DelegateMethod?

    // MARK: - Public methods

    func reset() {
        invokedMethod = nil
    }

    // MARK: - `GradientActivityIndicatorViewModelDelegate`

    func startAnimatingLocations(values: GradientLocationAnimationMatrix, duration: TimeInterval) {
        invokedMethod = .startAnimatingLocations(values: values, duration: duration)
    }

    func stopAnimatingLocations() {
        invokedMethod = .stopAnimatingLocations
    }
}
