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

    // MARK: - Test property `isHidden`

    func test_settingIsHidden_toTrue_shouldUpdateIsAnimatingSubject_withFalse() throws {
        // Given
        var receivedIsAnimating: Bool?
        let disposable = viewModel.isAnimating.subscribe { isAnimating, _ in
            receivedIsAnimating = isAnimating
        }

        let isHidden = true

        // When
        withExtendedLifetime(disposable) {
            viewModel.isHidden = isHidden
        }

        // Then
        let expectedIsAnimating = !isHidden
        XCTAssertEqual(receivedIsAnimating, expectedIsAnimating)
    }

    func test_settingIsHidden_toFalse_shouldUpdateIsAnimatingSubject_withTrue() throws {
        // Given
        var receivedIsAnimating: Bool?
        let disposable = viewModel.isAnimating.subscribe { isAnimating, _ in
            receivedIsAnimating = isAnimating
        }

        let isHidden = false

        // When
        withExtendedLifetime(disposable) {
            viewModel.isHidden = isHidden
        }

        // Then
        let expectedIsAnimating = !isHidden
        XCTAssertEqual(receivedIsAnimating, expectedIsAnimating)
    }

    // MARK: - Test property `bounds`

    func test_settingBounds_shouldUpdateGradientLayerSizeUpdate() {
        // Given
        var receivedSizeUpdate: GradientActivityIndicatorViewModel.SizeUpdate?
        let disposable = viewModel.gradientLayerSizeUpdate.subscribe { sizeUpdate, _ in
            receivedSizeUpdate = sizeUpdate
        }

        let size = CGSize(width: .random(in: 1 ... 100), height: .random(in: 1 ... 100))
        let bounds = CGRect(origin: .zero, size: size)

        // When
        withExtendedLifetime(disposable) {
            viewModel.bounds = bounds
        }

        // Then
        let expectedSizeUpdate =
            GradientActivityIndicatorViewModel.SizeUpdate(frame: CGRect(x: 0, y: 0, width: size.width * 3, height: size.height),
                                                          fromValue: size.width * -2)

        XCTAssertEqual(receivedSizeUpdate, expectedSizeUpdate)
    }

    func test_settingBounds_shouldRestartAnimation() {
        // Given
        var receivedIsAnimating = [Bool]()
        let disposable = viewModel.isAnimating.subscribe { isAnimating, _ in
            receivedIsAnimating.append(isAnimating)
        }
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(disposable) {
            viewModel.bounds = CGRect(origin: .zero, size: .zero)
        }

        // Then
        let expectedIsAnimating = [false, true]
        XCTAssertEqual(receivedIsAnimating, expectedIsAnimating)
    }

    func test_settingBounds_shouldNotRestartAnimation_dueToViewIsHidden() {
        // Given
        var receivedIsAnimating = [Bool]()
        let disposable = viewModel.isAnimating.subscribe { isAnimating, _ in
            receivedIsAnimating.append(isAnimating)
        }

        viewModel.isHidden = true
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(disposable) {
            viewModel.bounds = CGRect(origin: .zero, size: .zero)
        }

        // Then
        XCTAssertTrue(receivedIsAnimating.isEmpty)
    }

    // MARK: - Test property `gradientColors`

    func test_settingGradientColors_shouldUpdateGradientLayerColors() {
        // Given
        var receivedGradientLayerColors: [CGColor]?
        let disposable = viewModel.gradientLayerColors.subscribe { gradientLayerColors, _ in
            receivedGradientLayerColors = gradientLayerColors
        }

        let gradientColors: [UIColor] = [.red, .yellow, .green]

        // When
        withExtendedLifetime(disposable) {
            viewModel.gradientColors = gradientColors
        }

        // Then
        let expectedGradientLayerColors = [UIColor.red, .yellow, .green, .yellow, .red, .yellow, .green].map { $0.cgColor }
        XCTAssertEqual(receivedGradientLayerColors, expectedGradientLayerColors)
    }

    // MARK: - Test property `progressAnimationDuration`

    func test_settingProgressAnimationDuration_shouldUpdategGradientLayerAnimationDuration() {
        // Given
        var receivedGradientLayerAnimationDuration: TimeInterval?
        let disposable = viewModel.gradientLayerAnimationDuration.subscribe { gradientLayerAnimationDuration, _ in
            receivedGradientLayerAnimationDuration = gradientLayerAnimationDuration
        }

        let progressAnimationDuration: TimeInterval = .random(in: 0 ... 100)

        // When
        withExtendedLifetime(disposable) {
            viewModel.progressAnimationDuration = progressAnimationDuration
        }

        // Then
        XCTAssertEqual(receivedGradientLayerAnimationDuration, progressAnimationDuration)
    }

    func test_settingProgressAnimationDuration_shouldRestartAnimation() {
        // Given
        var receivedIsAnimating = [Bool]()
        let disposable = viewModel.isAnimating.subscribe { isAnimating, _ in
            receivedIsAnimating.append(isAnimating)
        }
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(disposable) {
            viewModel.progressAnimationDuration = .random(in: 0 ... 100)
        }

        // Then
        let expectedIsAnimating = [false, true]
        XCTAssertEqual(receivedIsAnimating, expectedIsAnimating)
    }

    func test_settingProgressAnimationDuration_shouldNotRestartAnimation_dueToViewIsHidden() {
        // Given
        var receivedIsAnimating = [Bool]()
        let disposable = viewModel.isAnimating.subscribe { isAnimating, _ in
            receivedIsAnimating.append(isAnimating)
        }

        viewModel.isHidden = true
        receivedIsAnimating.removeAll()

        // When
        withExtendedLifetime(disposable) {
            viewModel.progressAnimationDuration = .random(in: 0 ... 100)
        }

        // Then
        XCTAssertTrue(receivedIsAnimating.isEmpty)
    }
}
