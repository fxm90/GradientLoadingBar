//
//  GradientActivityIndicatorView+AnimateIsHiddenTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 19.05.19.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

// swiftlint:disable:next type_name
final class GradientActivityIndicatorViewAnimateIsHiddenTestCase: XCTestCase {

    // MARK: - Private properties

    private var window: UIWindow!
    private var gradientActivityIndicatorView: GradientActivityIndicatorView!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        // In order for UIView animations to be executed correctly, the corresponding view has to be attached to a visible window.
        // Therefore we're gonna use the current key-window, add our testing view here in `setUp()` and remove it later in `tearDown()`.
        window = UIApplication.shared.keyWindowInConnectedScenes

        gradientActivityIndicatorView = GradientActivityIndicatorView()
        window.addSubview(gradientActivityIndicatorView)
    }

    override func tearDown() {
        gradientActivityIndicatorView.removeFromSuperview()
        gradientActivityIndicatorView = nil

        window = nil

        super.tearDown()
    }

    // MARK: - Test method `animate(isHidden:)`

    func test_animateIsHidden_shouldShowView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // Hide view to validate fade-in.
        gradientActivityIndicatorView.alpha = 0
        gradientActivityIndicatorView.isHidden = true

        // When
        gradientActivityIndicatorView.animate(isHidden: false, duration: 0.1) { isFinished in
            XCTAssertTrue(isFinished)
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 1, accuracy: CGFloat.ulpOfOne)
    }

    func test_animateIsHidden_withInterruption_shouldShowView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // Hide view to validate fade-in.
        gradientActivityIndicatorView.alpha = 0
        gradientActivityIndicatorView.isHidden = true

        // When
        gradientActivityIndicatorView.animate(isHidden: false, duration: 0.1) { isFinished in
            XCTAssertFalse(isFinished)
            expectation.fulfill()
        }

        // Cancel animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden)
    }

    func test_animateIsHidden_shouldHideView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // When
        gradientActivityIndicatorView.animate(isHidden: true, duration: 0.1) { isFinished in
            XCTAssertTrue(isFinished)
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 0, accuracy: CGFloat.ulpOfOne)
    }

    func test_animateIsHidden_withInterruption_shouldNotHideView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // When
        gradientActivityIndicatorView.animate(isHidden: true, duration: 0.1) { isFinished in
            XCTAssertFalse(isFinished)
            expectation.fulfill()
        }

        // Cancel animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden, "As we've interrupted the animation, we expect the `isHidden` flag to still be `false`.")
    }

    // MARK: - Test method `fadeIn()`

    func test_fadeIn_shouldShowView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // Hide view to validate fade-in.
        gradientActivityIndicatorView.alpha = 0
        gradientActivityIndicatorView.isHidden = true

        // When
        gradientActivityIndicatorView.fadeIn(duration: 0.1) { isFinished in
            XCTAssertTrue(isFinished)
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 1, accuracy: CGFloat.ulpOfOne)
    }

    func test_fadeIn_withInterruption_shouldShowView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // Hide view to validate fade-in.
        gradientActivityIndicatorView.alpha = 0
        gradientActivityIndicatorView.isHidden = true

        // When
        gradientActivityIndicatorView.fadeIn(duration: 0.1) { isFinished in
            XCTAssertFalse(isFinished)
            expectation.fulfill()
        }

        // Cancel animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden)
    }

    // MARK: - Test method `fadeOut()`

    func test_fadeOut_shouldHideView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // When
        gradientActivityIndicatorView.fadeOut(duration: 0.1) { isFinished in
            XCTAssertTrue(isFinished)
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertTrue(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 0, accuracy: CGFloat.ulpOfOne)
    }

    func test_fadeOut_withInterruption_shouldNotHideView_andCallCompletionHandler() {
        // Given
        let expectation = expectation(description: "Expect completion handler to be invoked.")

        // When
        gradientActivityIndicatorView.fadeOut(duration: 0.1) { isFinished in
            XCTAssertFalse(isFinished)
            expectation.fulfill()
        }

        // Cancel animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        wait(for: [expectation], timeout: 1)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden, "As we've interrupted the animation, we expect the `isHidden` flag to still be `false`.")
    }
}
