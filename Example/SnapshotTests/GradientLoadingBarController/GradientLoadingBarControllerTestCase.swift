//
//  GradientLoadingBarControllerTestCase.swift
//  GradientLoadingBar_SnapshotTests
//
//  Created by Felix Mau on 06/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import GradientLoadingBar

class GradientLoadingBarControllerTestCase: XCTestCase {
    // MARK: - Private properties

    private var gradientLoadingBarController: GradientLoadingBarController!

    // MARK: - Public methods

    override func setUpWithError() throws {
        try super.setUpWithError()

        gradientLoadingBarController = GradientLoadingBarController()
        gradientLoadingBarController.fadeIn(duration: 0)
    }

    override func tearDownWithError() throws {
        gradientLoadingBarController = nil

        try super.tearDownWithError()
    }

    // MARK: - Tests

    func testGradientLoadingBarController() {
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
