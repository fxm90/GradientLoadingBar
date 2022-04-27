//
//  GradientLoadingBarView+ViewModelTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 22.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import XCTest
import SwiftUI

@testable import GradientLoadingBar

// swiftlint:disable:next type_name
final class GradientLoadingBarView_ViewModelTestCase: XCTestCase {
    // MARK: - Test property `gradientColors`

    func test_initialGradientColors_shouldIncludeReversedGradientColors() {
        // Given
        let gradientColors: [Color] = [.red, .yellow, .green]

        // When
        let viewModel = GradientLoadingBarView.ViewModel(gradientColors: gradientColors, progressDuration: 1)

        // Then
        let expectedGradientColors: [Color] = [.red, .yellow, .green, .yellow, .red, .yellow, .green]
        XCTAssertEqual(viewModel.gradientColors, expectedGradientColors)
    }

    // MARK: - Test property `horizontalOffset`

    func test_initialHorizontalOffset_shouldBeZero() {
        // When
        let viewModel = GradientLoadingBarView.ViewModel(gradientColors: [], progressDuration: 1)

        // Then
        XCTAssertEqual(viewModel.horizontalOffset, 0)
    }

    func test_settingSize_shouldUpdateHorizontalOffset() {
        // Given
        let viewModel = GradientLoadingBarView.ViewModel(gradientColors: [], progressDuration: 1)
        let size = CGSize(width: .random(in: 1 ... 100_000), height: .random(in: 1 ... 100_000))

        var receivedValues = [CGFloat]()
        let subscription = viewModel.$horizontalOffset.sink {
            receivedValues.append($0)
        }

        withExtendedLifetime(subscription) {
            // When
            viewModel.size = size
        }

        // Then
        let expectedValues = [0, -size.width, size.width]
        XCTAssertEqual(receivedValues, expectedValues)
    }

    // MARK: - Test property `gradientWidth`

    func test_initialGradientWidth_shouldBeZero() {
        // When
        let viewModel = GradientLoadingBarView.ViewModel(gradientColors: [], progressDuration: 1)

        // Then
        XCTAssertEqual(viewModel.gradientWidth, 0)
    }

    func test_settingSize_shouldUpdateGradientWidth() {
        // Given
        let viewModel = GradientLoadingBarView.ViewModel(gradientColors: [], progressDuration: 1)
        let size = CGSize(width: .random(in: 1 ... 100_000), height: .random(in: 1 ... 100_000))

        // When
        viewModel.size = size

        // Then
        XCTAssertEqual(viewModel.gradientWidth, size.width * 3)
    }
}
