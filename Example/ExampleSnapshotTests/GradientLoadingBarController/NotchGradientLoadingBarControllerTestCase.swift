//
//  NotchGradientLoadingBarControllerTestCase.swift
//  ExampleSnapshotTests
//
//  Created by Felix Mau on 14.06.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import GradientLoadingBar

final class NotchGradientLoadingBarControllerTestCase: XCTestCase {
    // swiftlint:disable:previous type_name

    // MARK: - Tests

    func test_notchGradientLoadingBarController() {
        // Given
        let rootViewController = UIViewController()
        let notchGradientLoadingBarController = NotchGradientLoadingBarController()

        // When
        notchGradientLoadingBarController.fadeIn(duration: 0)

        let expectation = expectation(description: "Wait for view to appear.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        assertSnapshot(matching: rootViewController, as: .windowedImage)
    }
}
