//
//  NotchGradientLoadingBarViewModelTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

class NotchGradientLoadingBarViewModelTestCase: XCTestCase {
    func testInitializerShouldSetSafeAreaDeviceToIPhoneX() {
        // Given
        let deviceIdentifiers = ["iPhone10,3", "iPhone10,6", "iPhone11,2", "iPhone11,4", "iPhone11,6", "iPhone11,8"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhoneX)
        }
    }

    func testInitializerShouldSetSafeAreaDeviceToIPhone11() {
        // Given
        let deviceIdentifiers = ["iPhone12,1", "iPhone12,3", "iPhone12,5"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhone11)
        }
    }

    func testInitializerShouldSetSafeAreaDeviceToIPhone12() {
        // Given
        let deviceIdentifiers = ["iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhone12)
        }
    }

    func testInitializerShouldSetSafeAreaDeviceToIPhone13() {
        // Given
        let deviceIdentifiers = ["iPhone14,4", "iPhone14,5", "iPhone14,2", "iPhone14,3"]
        deviceIdentifiers.forEach { deviceIdentifier in

            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, .iPhone13)
        }
    }

    func testInitializerShouldSetSafeAreaDeviceToUnknown() {
        // Given
        let deviceIdentifier = "Foo-Bar-🤡"

        // When
        let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

        // Then
        XCTAssertEqual(viewModel.safeAreaDevice, .unknown)
    }
}
