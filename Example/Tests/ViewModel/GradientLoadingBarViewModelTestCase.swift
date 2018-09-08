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
    private var durations: Durations!
    private var sharedApplicationMock: SharedApplicationMock!
    private var notificationCenter: NotificationCenter!

    var viewModel: GradientLoadingBarViewModel!

    override func setUp() {
        super.setUp()

        superview = UIView()
        durations = Durations(fadeIn: 1.2,
                              fadeOut: 3.4,
                              progress: 5.6)

        sharedApplicationMock = SharedApplicationMock()
        notificationCenter = NotificationCenter()

        viewModel = GradientLoadingBarViewModel(superview: superview,
                                                durations: durations,
                                                sharedApplication: sharedApplicationMock,
                                                notificationCenter: notificationCenter)
    }

    override func tearDown() {
        viewModel = nil

        superview = nil
        durations = nil
        notificationCenter = nil
        sharedApplicationMock = nil

        super.tearDown()
    }

    // MARK: - Test `superview`

    func testListenerForSuperviewShouldBeInformedImmediately() {
        // When
        _ = viewModel.superview.observe { [weak self] nextValue, _ in
            // Then
            XCTAssertNotNil(nextValue)
            XCTAssertEqual(nextValue, self?.superview)
        }
    }

    func testListenerForSuperviewShouldBeInformedAfterUIWindowDidBecomeKeyNotification() {
        // Given
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    durations: durations,
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
        notificationCenter.post(name: .UIWindowDidBecomeKey,
                                object: nil)
    }

    func testListenerForSuperviewShouldBeInformedAfterUIWindowDidBecomeKeyNotificationJustOnce() {
        // Given
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    durations: durations,
                                                    sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        var observerCounter = 0

        var disposal = Disposal()
        viewModel.superview.observe { nextValue, _ in
            guard nextValue != nil else {
                // Skip initial call to observer.
                return
            }

            observerCounter += 1
        }.add(to: &disposal)

        // When
        for _ in 1 ... 3 {
            notificationCenter.post(name: .UIWindowDidBecomeKey,
                                    object: nil)
        }

        XCTAssertEqual(observerCounter, 1)
    }

    // MARK: - Test visibility

    func testShowShouldUpdateVisibility() {
        // When
        viewModel.show()

        // Then
        let receivedAnimatedVisibilityUpdate = viewModel.isVisible.value
        let expectedAnimatedVisibilityUpdate = makeAnimatedVisibilityUpdateForStateIsVisible

        XCTAssertEqual(receivedAnimatedVisibilityUpdate, expectedAnimatedVisibilityUpdate)
    }

    func testHideShouldUpdateVisibility() {
        // Given
        // Start by showing the gradient loading bar, so we'll notice the change.
        viewModel.show()

        // When
        viewModel.hide()

        // Then
        let receivedAnimatedVisibilityUpdate = viewModel.isVisible.value
        let expectedAnimatedVisibilityUpdate = makeAnimatedVisibilityUpdateForStateIsHidden

        XCTAssertEqual(receivedAnimatedVisibilityUpdate, expectedAnimatedVisibilityUpdate)
    }

    func testToggleShouldUpdateVisibility() {
        // Given
        for idx in 1 ... 5 {
            // When
            viewModel.toggle()

            // Then
            let receivedAnimatedVisibilityUpdate = viewModel.isVisible.value
            let expectedAnimatedVisibilityUpdate: GradientLoadingBarViewModel.AnimatedVisibilityUpdate

            let viewShouldBeHidden = idx % 2 == 0
            if viewShouldBeHidden {
                expectedAnimatedVisibilityUpdate = makeAnimatedVisibilityUpdateForStateIsHidden
            } else {
                expectedAnimatedVisibilityUpdate = makeAnimatedVisibilityUpdateForStateIsVisible
            }

            XCTAssertEqual(receivedAnimatedVisibilityUpdate, expectedAnimatedVisibilityUpdate)
        }
    }
}

// MARK: - Helpers

extension GradientLoadingBarViewModelTestCase {
    /// Returns an object for animated visibility updates from state visible to hidden.
    var makeAnimatedVisibilityUpdateForStateIsHidden: GradientLoadingBarViewModel.AnimatedVisibilityUpdate {
        // swiftlint:disable:previous identifier_name
        return GradientLoadingBarViewModel.AnimatedVisibilityUpdate(duration: durations.fadeOut,
                                                                    alpha: 0.0,
                                                                    isHidden: true)
    }

    /// Returns an object for animated visibility updates from state hidden to visible.
    var makeAnimatedVisibilityUpdateForStateIsVisible: GradientLoadingBarViewModel.AnimatedVisibilityUpdate {
        // swiftlint:disable:previous identifier_name
        return GradientLoadingBarViewModel.AnimatedVisibilityUpdate(duration: durations.fadeIn,
                                                                    alpha: 1.0,
                                                                    isHidden: false)
    }
}

// MARK: - Mocks

class SharedApplicationMock: UIApplicationProtocol {
    var keyWindow: UIWindow?
}
