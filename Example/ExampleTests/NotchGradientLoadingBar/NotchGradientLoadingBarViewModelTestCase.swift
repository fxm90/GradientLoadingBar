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

    func test_initializer_shouldSetCorrectSafeAreaDevice() {
        // Given
        let identifiersToSafeAreaDeviceMap: [String: NotchGradientLoadingBarViewModel.SafeAreaDevice] = [
            "iPhone10,3": .iPhoneX,
            "iPhone10,6": .iPhoneX,
            "iPhone11,2": .iPhoneXS,
            "iPhone11,4": .iPhoneXSMax,
            "iPhone11,6": .iPhoneXSMax,
            "iPhone11,8": .iPhoneXR,
            "iPhone12,1": .iPhone11,
            "iPhone12,3": .iPhone11Pro,
            "iPhone12,5": .iPhone11ProMax,
            "iPhone13,1": .iPhone12Mini,
            "iPhone13,2": .iPhone12,
            "iPhone13,3": .iPhone12Pro,
            "iPhone13,4": .iPhone12ProMax,
            "iPhone14,4": .iPhone13Mini,
            "iPhone14,5": .iPhone13,
            "iPhone14,2": .iPhone13Pro,
            "iPhone14,3": .iPhone13ProMax,
        ]

        identifiersToSafeAreaDeviceMap.forEach { deviceIdentifier, safeAreaDevice in
            // When
            let viewModel = NotchGradientLoadingBarViewModel(deviceIdentifier: deviceIdentifier)

            // Then
            XCTAssertEqual(viewModel.safeAreaDevice, safeAreaDevice)
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
