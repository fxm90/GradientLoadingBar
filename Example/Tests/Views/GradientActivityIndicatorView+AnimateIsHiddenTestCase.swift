//
//  GradientActivityIndicatorView+AnimateIsHiddenTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 19/05/19.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

// swiftlint:disable:next type_name
class GradientActivityIndicatorViewAnimateIsHiddenTestCase: XCTestCase {
    // MARK: - Private properties

    private var window: UIWindow!
    private var gradientActivityIndicatorView: GradientActivityIndicatorView!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        // In order for UIView animations to be executed correctly, the corresponding view has to be attached to a visible window.
        // Therefore we're gonna use the current key-window, add our testing view here in `setUp()` and remove it later in `tearDown()`.
        window = UIApplication.shared.keyWindow

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

    func testAnimateIsHiddenShouldShowViewAndCallCompletionHandler() {
        // Given
        let expectation = self.expectation(description: "Expect completion handler to be called.")

        // Hide view to validate fade-in.
        gradientActivityIndicatorView.alpha = 0.0
        gradientActivityIndicatorView.isHidden = true

        // When
        gradientActivityIndicatorView.animate(isHidden: false, duration: 0.1) { _ in
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 0.2)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 1.0, accuracy: CGFloat.ulpOfOne)
    }

    func testAnimateIsHiddenShouldHideViewAndCallCompletionHandler() {
        // Given
        let expectation = self.expectation(description: "Expect completion handler to be called.")

        // When
        gradientActivityIndicatorView.animate(isHidden: true, duration: 0.1) { _ in
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 0.2)

        XCTAssertTrue(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 0.0, accuracy: CGFloat.ulpOfOne)
    }

    func testAnimateIsHiddenWithCancelationShouldResetIsHiddenFlagAndCallCompletionHandler() {
        // Given
        let expectation = self.expectation(description: "Expect completion handler to be called.")

        // When
        gradientActivityIndicatorView.animate(isHidden: true, duration: 0.1) { _ in
            expectation.fulfill()
        }

        // Cancel animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        wait(for: [expectation], timeout: 0.2)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden, "As we've interrupted the animation, we expect the `isHidden` flag to still be `false`.")
    }

    // MARK: - Test method `fadeIn()`

    func testFadeInShouldShowViewAndCallCompletionHandler() {
        // Given
        let expectation = self.expectation(description: "Expect completion handler to be called.")

        // Hide view to validate fade-in.
        gradientActivityIndicatorView.alpha = 0.0
        gradientActivityIndicatorView.isHidden = true

        // When
        gradientActivityIndicatorView.fadeIn(duration: 0.1) { _ in
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 0.2)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 1.0, accuracy: CGFloat.ulpOfOne)
    }

    // MARK: - Test method `fadeOut()`

    func testFadeOutShouldHideViewAndCallCompletionHandler() {
        // Given
        let expectation = self.expectation(description: "Expect completion handler to be called.")

        // When
        gradientActivityIndicatorView.fadeOut(duration: 0.1) { _ in
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 0.2)

        XCTAssertTrue(gradientActivityIndicatorView.isHidden)
        XCTAssertEqual(gradientActivityIndicatorView.alpha, 0.0, accuracy: CGFloat.ulpOfOne)
    }

    func testFadeOutWithCancelationShouldResetIsHiddenFlagAndCallCompletionHandler() {
        // Given
        let expectation = self.expectation(description: "Expect completion handler to be called.")

        // When
        gradientActivityIndicatorView.fadeOut(duration: 0.1) { _ in
            expectation.fulfill()
        }

        // Cancel animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        wait(for: [expectation], timeout: 0.2)

        XCTAssertFalse(gradientActivityIndicatorView.isHidden, "As we've interrupted the animation, we expect the `isHidden` flag to still be `false`.")
    }
}
