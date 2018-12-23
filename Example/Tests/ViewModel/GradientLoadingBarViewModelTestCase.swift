//
//  GradientLoadingBarViewModelTestCase.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 12/26/17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest
import Observable

@testable import GradientLoadingBar

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

    // MARK: - Test observable `superview`

    func testInitializerShouldSetupSuperviewObservableWithCustomSuperview() {
        // Then
        XCTAssertEqual(viewModel.superview.value,
                       superview,
                       "We passed a custom superview to the view-model in `setUp()`, and therfore expect this view to be the superview.")
    }

    func testInitializerShouldSetupSuperviewObservableWithKeyWindow() {
        // Given
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        // When
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    durations: durations,
                                                    sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        // Then
        XCTAssertEqual(viewModel.superview.value,
                       keyWindow)
    }

    func testInitializerShouldSetupSuperviewObservableAfterUIWindowDidBecomeKeyNotification() {
        // Given
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    durations: durations,
                                                    sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        let keyWindow = UIWindow()

        // When
        sharedApplicationMock.keyWindow = keyWindow
        notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                object: nil)

        // Then
        XCTAssertEqual(viewModel.superview.value,
                       keyWindow)
    }

    func testInitializerShouldSetupSuperviewObservableAfterUIWindowDidBecomeKeyNotificationJustOnce() {
        // Given
        let viewModel = GradientLoadingBarViewModel(superview: nil,
                                                    durations: durations,
                                                    sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        var observerCounter = 0

        var disposal = Disposal()
        viewModel.superview.observe { newSuperview, _ in
            guard newSuperview != nil else {
                // Skip initial call to observer.
                return
            }

            observerCounter += 1
        }.add(to: &disposal)

        // When
        for _ in 1 ... 3 {
            sharedApplicationMock.keyWindow = UIWindow()
            notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                    object: nil)
        }

        // Then
        XCTAssertEqual(observerCounter, 1)
    }

    // MARK: - Test observable `animatedVisibilityUpdate`

    func testInitializerShouldSetupAnimatedVisibilityUpdateObservableWithImmediatelyHidden() {
        // Then
        let receivedAnimatedVisibilityUpdate = viewModel.animatedVisibilityUpdate.value
        let expectedAnimatedVisibilityUpdate = GradientLoadingBarViewModel.AnimatedVisibilityUpdate.immediatelyHidden

        XCTAssertEqual(receivedAnimatedVisibilityUpdate, expectedAnimatedVisibilityUpdate)
    }

    func testShowShouldUpdateAnimatedVisibilityUpdateObservable() {
        // When
        viewModel.show()

        // Then
        let receivedAnimatedVisibilityUpdate = viewModel.animatedVisibilityUpdate.value
        let expectedAnimatedVisibilityUpdate = makeAnimatedVisibilityUpdateForStateIsVisible

        XCTAssertEqual(receivedAnimatedVisibilityUpdate, expectedAnimatedVisibilityUpdate)
    }

    func testHideShouldUpdateAnimatedVisibilityUpdateObservable() {
        // When
        viewModel.hide()

        // Then
        let receivedAnimatedVisibilityUpdate = viewModel.animatedVisibilityUpdate.value
        let expectedAnimatedVisibilityUpdate = makeAnimatedVisibilityUpdateForStateIsHidden

        XCTAssertEqual(receivedAnimatedVisibilityUpdate, expectedAnimatedVisibilityUpdate)
    }

    func testToggleShouldUpdateAnimatedVisibilityUpdateObservable() {
        // Given
        for idx in 1 ... 5 {
            // When
            viewModel.toggle()

            // Then
            let receivedAnimatedVisibilityUpdate = viewModel.animatedVisibilityUpdate.value
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
                                                                    isHidden: true)
    }

    /// Returns an object for animated visibility updates from state hidden to visible.
    var makeAnimatedVisibilityUpdateForStateIsVisible: GradientLoadingBarViewModel.AnimatedVisibilityUpdate {
        // swiftlint:disable:previous identifier_name
        return GradientLoadingBarViewModel.AnimatedVisibilityUpdate(duration: durations.fadeIn,
                                                                    isHidden: false)
    }
}

// MARK: - Mocks

class SharedApplicationMock: UIApplicationProtocol {
    var keyWindow: UIWindow?
}
