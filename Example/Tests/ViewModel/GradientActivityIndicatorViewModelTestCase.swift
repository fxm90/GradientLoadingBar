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
    // MARK: - Types

    typealias AnimationState = GradientActivityIndicatorViewModel.AnimationState

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

    // MARK: - Test observable `animationState`

    func testInitializerShouldSetAnimationStateToAnimatingWithCurrentProgressDuration() {
        let expectedAnimationState: AnimationState =
            .animating(duration: viewModel.progressAnimationDuration)

        XCTAssertEqual(viewModel.animationState.value, expectedAnimationState)
    }

    // MARK: - Test observable `infinteGradientColors`

    func testInitializerShouldSetInfinteGradientColorsBasedOnCurrentGradientColors() {
        let extectedInfinteGradientColors =
            makeInfiniteGradientColors(from: viewModel.gradientColors)

        XCTAssertEqual(viewModel.infinteGradientColors.value, extectedInfinteGradientColors)
    }

    // MARK: - Test setting property `isHidden`

    func testSettingIsHiddenToTrueShouldSetAnimationStateToNone() {
        // When
        viewModel.isHidden = true

        // Then
        XCTAssertEqual(viewModel.animationState.value, .none)
    }

    func testSettingIsHiddenToFalseShouldSetAnimationStateToAnimatingWithCurrentProgressDuration() {
        // Given
        let progressAnimationDuration = 1.23
        viewModel.progressAnimationDuration = progressAnimationDuration

        // When
        viewModel.isHidden = false

        // Then
        let expectedAnimationState: AnimationState =
            .animating(duration: progressAnimationDuration)

        XCTAssertEqual(viewModel.animationState.value, expectedAnimationState)
    }

    // MARK: - Test setting property `gradientColors`

    func testSettingGradientColorsShouldUpdateInfinteGradientColors() {
        // Given
        let colors: [UIColor] = [.red, .yellow, .green]

        // When
        viewModel.gradientColors = colors

        // Then
        let extectedInfinteGradientColors =
            makeInfiniteGradientColors(from: colors)

        XCTAssertEqual(viewModel.infinteGradientColors.value, extectedInfinteGradientColors)
    }
}

// MARK: - Helpers

extension GradientActivityIndicatorViewModelTestCase {
    private func makeInfiniteGradientColors(from gradientColors: [UIColor]) -> [CGColor] {
        let reversedColors = gradientColors
            .reversed()
            .dropFirst()
            .dropLast()

        let infiniteGradientColors = gradientColors + reversedColors + gradientColors
        return infiniteGradientColors.map { $0.cgColor }
    }
}
