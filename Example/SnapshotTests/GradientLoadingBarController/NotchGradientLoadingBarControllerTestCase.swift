//
//  NotchGradientLoadingBarControllerTestCase.swift
//  GradientLoadingBar_SnapshotTests
//
//  Created by Felix Mau on 06/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import GradientLoadingBar

class NotchGradientLoadingBarControllerTestCase: XCTestCase {
    // swiftlint:disable:previous type_name

    // MARK: - Private properties

    private var notchGradientLoadingBarController: NotchGradientLoadingBarController!

    // MARK: - Public methods

    override func setUpWithError() throws {
        try super.setUpWithError()

        notchGradientLoadingBarController = NotchGradientLoadingBarController()
        notchGradientLoadingBarController.fadeIn(duration: 0)
    }

    override func tearDownWithError() throws {
        notchGradientLoadingBarController = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testNotchGradientLoadingBarController() {
        // Given
        let rootViewController = UIViewController()

        let expectation = self.expectation(description: "Waiting for view to appear.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)
        assertSnapshot(matching: rootViewController, as: .windowedImage)
    }
}
