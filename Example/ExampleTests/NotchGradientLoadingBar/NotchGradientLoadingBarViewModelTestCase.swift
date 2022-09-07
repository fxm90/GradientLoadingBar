//
//  NotchGradientLoadingBarViewModelTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

final class NotchGradientLoadingBarViewModelTestCase: XCTestCase {

    func test_initializer_shouldSetSafeAreaDevice_toIPhoneX() {
        // Given
        let deviceIdentifiers = ["iPhone10,3", "iPhone10,6", "iPhone11,2", "iPhone11,4", "iPhone11,6"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhoneX)
        }
    }

    func test_initializer_shouldSetSafeAreaDevice_toIPhoneXR() {
        // Given
        let deviceIdentifier = "iPhone11,8"

        // When
        let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

        // Then
        XCTAssertEqual(viewModel.safeAreaDevice, .iPhoneXR)
    }

    func test_initializer_shouldSetSafeAreaDevice_toIPhone11() {
        // Given
        let deviceIdentifier = "iPhone12,1"

        // When
        let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

        // Then
        XCTAssertEqual(viewModel.safeAreaDevice, .iPhone11)
    }

    func test_initializer_shouldSetSafeAreaDevice_toIPhone11Pro() {
        // Given
        let deviceIdentifier = "iPhone12,3"

        // When
        let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

        // Then
        XCTAssertEqual(viewModel.safeAreaDevice, .iPhone11Pro)
    }

    func test_initializer_shouldSetSafeAreaDevice_toIPhone11ProMax() {
        // Given
        let deviceIdentifier = "iPhone12,5"

        // When
        let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

        // Then
        XCTAssertEqual(viewModel.safeAreaDevice, .iPhone11ProMax)
    }

    func test_initializer_shouldSetSafeAreaDevice_toIPhone12() {
        // Given
        let deviceIdentifiers = ["iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhone12)
        }
    }

    func test_initializer_shouldSetSafeAreaDevice_toIPhone13() {
        // Given
        let deviceIdentifiers = ["iPhone14,4", "iPhone14,5", "iPhone14,2", "iPhone14,3"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhone13)
        }
    }

    func test_initializer_shouldSetSafeAreaDevice_toUnknown() {
        // Given
        let deviceIdentifier = "Foo-Bar-🤡"

        // When
        let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

        // Then
        XCTAssertEqual(viewModel.safeAreaDevice, .unknown)
    }
}
