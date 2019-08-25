//
//  GradientLoadingBarViewModelTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 12/26/17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest

@testable import LightweightObservable
@testable import GradientLoadingBar

class GradientLoadingBarViewModelTestCase: XCTestCase {
    // MARK: - Types

    typealias VisibilityAnimation = GradientLoadingBarViewModel.VisibilityAnimation

    // MARK: - Private properties

    private var sharedApplicationMock: SharedApplicationMock!
    private var notificationCenter: NotificationCenter!

    private var viewModel: GradientLoadingBarViewModel!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        sharedApplicationMock = SharedApplicationMock()
        notificationCenter = NotificationCenter()

        viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                notificationCenter: notificationCenter)
    }

    override func tearDown() {
        viewModel = nil

        notificationCenter = nil
        sharedApplicationMock = nil

        super.tearDown()
    }

    // MARK: - Test observable `superview`

    func testInitializerShouldSetupSuperviewObservableWithKeyWindow() {
        // Given
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        // When
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        // Then
        XCTAssertEqual(viewModel.superview.value,
                       keyWindow)
    }

    func testInitializerShouldSetupSuperviewObservableAfterUIWindowDidBecomeKeyNotification() {
        // Given
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
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
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        let expectation = self.expectation(description: "Expected observer for superview to be informed just once.")

        var disposeBag = DisposeBag()
        viewModel.superview.subscribe { newSuperview, _ in
            guard newSuperview != nil else {
                // Skip initial call to observer.
                return
            }

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        for _ in 1 ... 3 {
            sharedApplicationMock.keyWindow = UIWindow()
            notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                    object: nil)
        }

        // Then
        wait(for: [expectation], timeout: 0.1)
    }

    // MARK: - Test observable `visibilityAnimation`

    func testInitializerShouldSetupVisibilityAnimationObservableWithImmediatelyHidden() {
        // Then
        let receivedVisibilityAnimation = viewModel.visibilityAnimation.value
        let expectedVisibilityAnimation = VisibilityAnimation.immediatelyHidden

        XCTAssertEqual(receivedVisibilityAnimation, expectedVisibilityAnimation)
    }

    func testShowShouldUpdateVisibilityAnimationObservable() {
        // When
        viewModel.show()

        // Then
        let receivedVisibilityAnimation = viewModel.visibilityAnimation.value
        let expectedVisibilityAnimation = VisibilityAnimation(duration: viewModel.fadeInDuration,
                                                              isHidden: false)

        XCTAssertEqual(receivedVisibilityAnimation, expectedVisibilityAnimation)
    }

    func testHideShouldUpdateVisibilityAnimationObservable() {
        // When
        viewModel.hide()

        // Then
        let receivedVisibilityAnimation = viewModel.visibilityAnimation.value
        let expectedVisibilityAnimation = VisibilityAnimation(duration: viewModel.fadeOutDuration,
                                                              isHidden: true)

        XCTAssertEqual(receivedVisibilityAnimation, expectedVisibilityAnimation)
    }
}

// MARK: - Mocks

class SharedApplicationMock: UIApplicationProtocol {
    var keyWindow: UIWindow?
}
