//
//  GradientActivityIndicatorViewModelTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 08/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

@testable import LightweightObservable
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

    func testInitializerShouldSetIsAnimatingProgressToTrue() {
        XCTAssertTrue(viewModel.isAnimatingProgress.value)
    }

    func testInitializerShouldSetGradientLayerFrameToZero() {
        XCTAssertEqual(viewModel.gradientLayerFrame.value, .zero)
    }

    func testInitializerShouldSetGradientLayerAnimationFromValueToZero() {
        XCTAssertEqual(viewModel.gradientLayerAnimationFromValue.value, 0.0)
    }

    func testInitializerShouldSetgradientLayerAnimationDurationToValueFromProgressAnimationDuration() {
        XCTAssertEqual(viewModel.gradientLayerAnimationDuration.value, viewModel.progressAnimationDuration)
    }

    func testInitializerShouldSetGradientLayerColorsBasedOnCurrentGradientColors() {
        let extectedGradientLayerColors =
            makeGradientLayerColors(from: viewModel.gradientColors)

        XCTAssertEqual(viewModel.gradientLayerColors.value, extectedGradientLayerColors)
    }

    func testInitializerShouldSetIsHiddenToFalse() {
        XCTAssertFalse(viewModel.isHidden)
    }

    func testInitializerShouldSetBoundsToZero() {
        XCTAssertEqual(viewModel.bounds, .zero)
    }

    func testInitializerShouldSetGradientColorsToStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.gradientColors, UIColor.GradientLoadingBar.gradientColors)
    }

    func testInitializerShouldSetProgressAnimationDurationToStaticConfigurationProperty() {
        XCTAssertEqual(viewModel.progressAnimationDuration, TimeInterval.GradientLoadingBar.progressDuration)
    }

    // MARK: - Test setting property `isHidden`

    func testSettingIsHiddenToTrueShouldUpdateIsAnimatingProgressToFalse() {
        // When
        viewModel.isHidden = true

        // Then
        XCTAssertFalse(viewModel.isAnimatingProgress.value)
    }

    func testSettingIsHiddenToFalseShouldUpdateIsAnimatingProgressToTrue() {
        // When
        viewModel.isHidden = false

        // Then
        XCTAssertTrue(viewModel.isAnimatingProgress.value)
    }

    // MARK: - Test setting property `bounds`

    func testSettingBoundsShouldUpdateGradientLayerFrame() {
        // Given
        let bounds = CGRect(x: 1.0, y: 2.0, width: 3.0, height: 4.0)

        // When
        viewModel.bounds = bounds

        // Then
        let expectedFrame = CGRect(x: 0.0, y: 0.0, width: bounds.width * 3, height: bounds.height)
        XCTAssertEqual(viewModel.gradientLayerFrame.value, expectedFrame)
    }

    func testSettingBoundsShouldUpdateGradientLayerAnimationFromValue() {
        // Given
        let bounds = CGRect(x: 1.0, y: 2.0, width: 3.0, height: 4.0)

        // When
        viewModel.bounds = bounds

        // Then
        let expectedAnimationFromValue = -2 * bounds.size.width
        XCTAssertEqual(viewModel.gradientLayerAnimationFromValue.value, expectedAnimationFromValue)
    }

    func testSettingBoundsShouldInformDelegateToRestartAnimation() {
        // When
        viewModel.bounds = CGRect(x: 1.0, y: 2.0, width: 3.0, height: 4.0)

        // Then
        XCTAssertTrue(delegateMock.didCallRestartAnimation)
    }

    func testSettingBoundsShouldNotInformDelegateToRestartAnimationAsTheViewIsCurrentlyHidden() {
        // Given
        viewModel.isHidden = true

        // When
        viewModel.bounds = CGRect(x: 1.0, y: 2.0, width: 3.0, height: 4.0)

        // Then
        XCTAssertFalse(delegateMock.didCallRestartAnimation)
    }

    // MARK: - Test setting property `gradientColors`

    func testSettingGradientColorsShouldUpdateGradientLayerColors() {
        // Given
        let colors: [UIColor] = [.red, .yellow, .green]

        // When
        viewModel.gradientColors = colors

        // Then
        let extectedGradientLayerColors =
            makeGradientLayerColors(from: colors)

        XCTAssertEqual(viewModel.gradientLayerColors.value, extectedGradientLayerColors)
    }

    // MARK: - Test setting property `progressAnimationDuration`

    func testSettingProgressAnimationDurationShouldUpdateGradientLayerAnimationDuration() {
        // Given
        let progressAnimationDuration = 1.23

        // When
        viewModel.progressAnimationDuration = progressAnimationDuration

        // Then
        XCTAssertEqual(viewModel.gradientLayerAnimationDuration.value, progressAnimationDuration)
    }

    func testSettingProgressAnimationDurationShouldInformDelegateToRestartAnimation() {
        // When
        viewModel.progressAnimationDuration = 1.23

        // Then
        XCTAssertTrue(delegateMock.didCallRestartAnimation)
    }

    func testSettingProgressAnimationDurationShouldNotInformDelegateToRestartAnimationAsTheViewIsCurrentlyHidden() {
        // Given
        viewModel.isHidden = true

        // When
        viewModel.progressAnimationDuration = 1.23

        // Then
        XCTAssertFalse(delegateMock.didCallRestartAnimation)
    }
}

// MARK: - Helpers

extension GradientActivityIndicatorViewModelTestCase {
    private func makeGradientLayerColors(from gradientColors: [UIColor]) -> [CGColor] {
        let reversedColors = gradientColors
            .reversed()
            .dropFirst()
            .dropLast()

        let infiniteGradientColors = gradientColors + reversedColors + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }
}

// MARK: - Mocks

// swiftlint:disable:next type_name
class GradientActivityIndicatorViewModelDelegateMock: GradientActivityIndicatorViewModelDelegate {
    // MARK: - Public properties

    private(set) var didCallRestartAnimation = false

    // MARK: - Public methods

    func restartAnimation() {
        didCallRestartAnimation = true
    }
}
