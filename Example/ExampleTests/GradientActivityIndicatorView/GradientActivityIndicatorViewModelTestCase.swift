//
//  GradientActivityIndicatorViewModelTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest

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

    // MARK: - Test property `isHidden`

    func test_settingIsHidden_toTrue_shouldUpdateIsAnimatingSubject_withFalse() throws {
        // Given
        var receivedIsAnimating: Bool?
        let cancellable = viewModel.isAnimating.sink { isAnimating in
            receivedIsAnimating = isAnimating
        }

        // When
        withExtendedLifetime(cancellable) {
            viewModel.isHidden = true
        }

        // Then
        XCTAssertFalse(
            try XCTUnwrap(receivedIsAnimating, "Expected to have received a value from the subscription closure at this point.")
        )
    }

    func test_settingIsHidden_toFalse_shouldUpdateIsAnimatingSubject_withTrue() throws {
        // Given
        var receivedIsAnimating: Bool?
        let cancellable = viewModel.isAnimating.sink { isAnimating in
            receivedIsAnimating = isAnimating
        }

        // When
        withExtendedLifetime(cancellable) {
            viewModel.isHidden = false
        }

        // Then
        XCTAssertTrue(
            try XCTUnwrap(receivedIsAnimating, "Expected to have received a value from the subscription closure at this point.")
        )
    }

    // MARK: - Test property `bounds`

    func test_settingBounds_shouldUpdateGradientLayerSizeUpdate() {
        // Given
        var receivedSizeUpdate: GradientActivityIndicatorViewModel.SizeUpdate?
        let cancellable = viewModel.gradientLayerSizeUpdate.sink { sizeUpdate in
            receivedSizeUpdate = sizeUpdate
        }

        let size = CGSize(width: .random(in: 1 ... 100), height: .random(in: 1 ... 100))
        let bounds = CGRect(origin: .zero, size: size)

        // When
        withExtendedLifetime(cancellable) {
            viewModel.bounds = bounds
        }

        // Then
        let expectedSizeUpdate = GradientActivityIndicatorViewModel.SizeUpdate(bounds: bounds)
        XCTAssertEqual(receivedSizeUpdate, expectedSizeUpdate)
    }

    func test_settingBounds_shouldRestartAnimation() {
        // Given
        var receivedIsAnimating = [Bool]()
        let cancellable = viewModel.isAnimating.sink { isAnimating in
            receivedIsAnimating.append(isAnimating)
        }
        receivedIsAnimating.removeAll()

        let size = CGSize(width: .random(in: 1 ... 100), height: .random(in: 1 ... 100))
        let bounds = CGRect(origin: .zero, size: size)

        // When
        withExtendedLifetime(cancellable) {
            viewModel.bounds = bounds
        }

        // Then
        let expectedIsAnimating = [false, true]
        XCTAssertEqual(receivedIsAnimating, expectedIsAnimating)
    }

    func test_settingBounds_shouldNotRestartAnimation_dueToViewIsHidden() {
        // Given
        var receivedIsAnimating = [Bool]()
        let cancellable = viewModel.isAnimating.sink { isAnimating in
            receivedIsAnimating.append(isAnimating)
        }

        let size = CGSize(width: .random(in: 1 ... 100), height: .random(in: 1 ... 100))
        let bounds = CGRect(origin: .zero, size: size)

        viewModel.isHidden = true
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(cancellable) {
            viewModel.bounds = bounds
        }

        // Then
        XCTAssertTrue(receivedIsAnimating.isEmpty)
    }

    // MARK: - Test property `gradientColors`

    func test_settingGradientColors_shouldUpdateGradientLayerColors() {
        // Given
        var receivedGradientLayerColors: [CGColor]?
        let cancellable = viewModel.gradientLayerColors.sink { gradientLayerColors in
            receivedGradientLayerColors = gradientLayerColors
        }

        let gradientColors: [UIColor] = [.red, .yellow, .green]

        // When
        withExtendedLifetime(cancellable) {
            viewModel.gradientColors = gradientColors
        }

        // Then
        let expectedGradientLayerColors = [UIColor.red, .yellow, .green, .yellow, .red, .yellow, .green].map(\.cgColor)
        XCTAssertEqual(receivedGradientLayerColors, expectedGradientLayerColors)
    }

    // MARK: - Test property `progressAnimationDuration`

    func test_settingProgressAnimationDuration_shouldUpdateGradientLayerAnimationDuration() {
        // Given
        var receivedGradientLayerAnimationDuration: TimeInterval?
        let cancellable = viewModel.gradientLayerAnimationDuration.sink { gradientLayerAnimationDuration in
            receivedGradientLayerAnimationDuration = gradientLayerAnimationDuration
        }

        let progressAnimationDuration: TimeInterval = .random(in: 0 ... 100)

        // When
        withExtendedLifetime(cancellable) {
            viewModel.progressAnimationDuration = progressAnimationDuration
        }

        // Then
        XCTAssertEqual(receivedGradientLayerAnimationDuration, progressAnimationDuration)
    }

    func test_settingProgressAnimationDuration_shouldRestartAnimation() {
        // Given
        var receivedIsAnimating = [Bool]()
        let cancellable = viewModel.isAnimating.sink { isAnimating in
            receivedIsAnimating.append(isAnimating)
        }
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(cancellable) {
            viewModel.progressAnimationDuration = .random(in: 0 ... 100)
        }

        // Then
        let expectedIsAnimating = [false, true]
        XCTAssertEqual(receivedIsAnimating, expectedIsAnimating)
    }

    func test_settingProgressAnimationDuration_shouldNotRestartAnimation_dueToViewIsHidden() {
        // Given
        var receivedIsAnimating = [Bool]()
        let cancellable = viewModel.isAnimating.sink { isAnimating in
            receivedIsAnimating.append(isAnimating)
        }

        viewModel.isHidden = true
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(cancellable) {
            viewModel.progressAnimationDuration = .random(in: 0 ... 100)
        }

        // Then
        XCTAssertTrue(receivedIsAnimating.isEmpty)
    }
}
