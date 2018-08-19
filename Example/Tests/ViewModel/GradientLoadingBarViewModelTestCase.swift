//
//  GradientLoadingBarViewModelTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Observable
import XCTest

@testable import GradientLoadingBar

// MARK: - Test case

class GradientLoadingBarViewModelTestCase: XCTestCase {
    private var superview: UIView!
    private var sharedApplicationMock: SharedApplicationMock!
    private var notificationCenter: NotificationCenter!

    var viewModel: GradientLoadingBarViewModel!

    override func setUp() {
        super.setUp()

        superview = UIView()
        sharedApplicationMock = SharedApplicationMock()
        notificationCenter = NotificationCenter()

        viewModel = GradientLoadingBarViewModel(superview: superview,
                                                sharedApplication: sharedApplicationMock,
                                                notificationCenter: notificationCenter)
    }

    override func tearDown() {
        viewModel = nil

        superview = nil
        notificationCenter = nil
        sharedApplicationMock = nil

        super.tearDown()
    }

    // MARK: - Test `superview`

    func testListenerForSuperviewShouldBeInformedImmediately() {
        // WHen
        _ = viewModel.superview.observe { [weak self] nextValue, _ in
            // Then
            XCTAssertNotNil(nextValue)
            XCTAssertEqual(nextValue, self?.superview)
        }
    }

    func testListenerForSuperviewShouldBeInformedAfterUIWindowDidBecomeKeyNotification() {
        // Given
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        var disposal = Disposal()
        viewModel.superview.observe { nextValue, _ in
            guard let nextValue = nextValue else {
                // Skip initial call to observer.
                return
            }

            // Then
            XCTAssertEqual(nextValue, keyWindow)
        }.add(to: &disposal)

        // When
        notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                object: nil)
    }

    func testListenerForSuperviewShouldBeInformedAfterUIWindowDidBecomeKeyNotificationJustOnce() {
        // Given
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        var visiblityCounter = 0

        var disposal = Disposal()
        viewModel.superview.observe { nextValue, _ in
            guard nextValue != nil else {
                // Skip initial call to observer.
                return
            }

            visiblityCounter += 1
        }.add(to: &disposal)

        // When
        for _ in 1 ... 3 {
            notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                    object: nil)
        }

        XCTAssertEqual(visiblityCounter, 1)
    }

    // MARK: - Test visibility

    func testShowShouldUpdateVisibility() {
        // When
        viewModel.show()

        // Then
        XCTAssertTrue(viewModel.isVisible.value)
    }

    func testShowShouldUpdateVisibilityJustOnce() {
        // Given
        var visiblityCounter = 0

        var disposal = Disposal()
        viewModel.isVisible.observe { _, _ in
            visiblityCounter += 1
        }.add(to: &disposal)

        // When
        for _ in 1 ... 10 {
            viewModel.show()
        }

        // Then
        XCTAssertTrue(viewModel.isVisible.value)
        XCTAssertEqual(visiblityCounter, 2, "After the initial call to the observer, we expect it to be notified just one more time.")
    }

    func testHideShouldUpdateVisibility() {
        // Given
        // Start by showing the gradient loading bar, so we'll notice the change.
        viewModel.show()

        // When
        viewModel.hide()

        XCTAssertFalse(viewModel.isVisible.value)
    }

    func testHideShouldUpdateVisibilityJustOnce() {
        // Given
        // Start by showing the gradient loading bar, so we'll notice the change.
        viewModel.show()

        var visiblityCounter = 0

        var disposal = Disposal()
        viewModel.isVisible.observe { _, _ in
            visiblityCounter += 1
        }.add(to: &disposal)

        // When
        for _ in 1 ... 10 {
            viewModel.hide()
        }

        // Then
        XCTAssertFalse(viewModel.isVisible.value)
        XCTAssertEqual(visiblityCounter, 2, "After the initial call to the observer, we expect it to be notified just one more time.")
    }

    func testToggleShouldUpdateVisibility() {
        for idx in 1 ... 5 {
            viewModel.toggle()

            let isOdd = idx % 2 == 1
            XCTAssertEqual(viewModel.isVisible.value, isOdd)
        }
    }
}

// MARK: - Helper: Mock for `UIApplication`

class SharedApplicationMock: UIApplicationProtocol {
    var keyWindow: UIWindow?
}
