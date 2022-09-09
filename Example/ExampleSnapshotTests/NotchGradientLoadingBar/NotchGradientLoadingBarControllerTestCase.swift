//
//  NotchGradientLoadingBarControllerTestCase.swift
//  ExampleSnapshotTests
//
//  Created by Felix Mau on 14.06.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import SnapshotTesting
import XCTest

@testable import GradientLoadingBar

final class NotchGradientLoadingBarControllerTestCase: XCTestCase {
    // swiftlint:disable:previous type_name

    // MARK: - Private properties

    private var window: UIWindow!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        window = UIApplication.shared.keyWindowInConnectedScenes
    }

    override func tearDown() {
        window = nil

        super.tearDown()
    }

    // MARK: - Test cases

    func test_notchGradientLoadingBarController() {
        // Given
        // Show an empty view controller behind loading bar in our test.
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController

        let expectation = expectation(description: "Expect view to be completely visible.")

        // When
        let gradientLoadingBarController = NotchGradientLoadingBarController()
        gradientLoadingBarController.fadeIn(duration: 0) { _ in
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 0.1)

        // Workaround, as snapshotting a `UIWindow` is currently not supported and crashes when running all tests.
        assertSnapshot(matching: window.layer, as: .image)
    }
}
