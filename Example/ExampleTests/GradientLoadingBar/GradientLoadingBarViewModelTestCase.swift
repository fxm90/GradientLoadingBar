//
//  GradientLoadingBarViewModelTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Combine
import XCTest

@testable import GradientLoadingBar

final class GradientLoadingBarViewModelTestCase: XCTestCase {

    // MARK: - Private properties

    private var sharedApplicationMock: SharedApplicationMock!
    private var notificationCenter: NotificationCenter!

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        sharedApplicationMock = SharedApplicationMock()
        notificationCenter = NotificationCenter()
    }

    override func tearDown() {
        notificationCenter = nil
        sharedApplicationMock = nil

        super.tearDown()
    }

    // MARK: - Test observable `superview`

    func test_init_shouldSetupSuperviewObservable_withNil() throws {
        // When
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        var receivedValues = [UIView?]()
        let cancellable = viewModel.superview.sink {
            receivedValues.append($0)
        }

        // Then
        withExtendedLifetime(cancellable) {
            XCTAssertEqual(receivedValues, [nil])
        }
    }

    func test_init_shouldSetupSuperviewObservable_withKeyWindow() throws {
        // Given
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindowInConnectedScenes = keyWindow

        // When
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        // Then
        var receivedValues = [UIView?]()
        let cancellable = viewModel.superview.sink {
            receivedValues.append($0)
        }

        // Then
        withExtendedLifetime(cancellable) {
            XCTAssertEqual(receivedValues, [keyWindow])
        }
    }

    func test_init_shouldSetupSuperviewObservable_afterUIWindowDidBecomeKeyNotification() {
        // Given
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        var receivedKeyWindows = [UIView?]()
        let cancellable = viewModel.superview.sink { keyWindow in
            receivedKeyWindows.append(keyWindow)
        }

        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindowInConnectedScenes = keyWindow

        // When
        withExtendedLifetime(cancellable) {
            notificationCenter.post(name: UIWindow.didBecomeKeyNotification, object: nil)
        }

        // Then
        let expectedKeyWindows = [nil, keyWindow]
        XCTAssertEqual(receivedKeyWindows, expectedKeyWindows)
    }

    func test_deinit_shouldResetSuperviewObservable_withNil() {
        // Given
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindowInConnectedScenes = keyWindow

        var viewModel: GradientLoadingBarViewModel? = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                                                  notificationCenter: notificationCenter)

        var receivedKeyWindows = [UIView?]()
        let cancellable = viewModel?.superview.sink { keyWindow in
            receivedKeyWindows.append(keyWindow)
        }

        // When
        withExtendedLifetime(cancellable) {
            viewModel = nil
        }

        // Then
        let expectedKeyWindows = [keyWindow, nil]
        XCTAssertEqual(receivedKeyWindows, expectedKeyWindows)
    }
}

// MARK: - Mocks

private final class SharedApplicationMock: UIApplicationProtocol {
    var keyWindowInConnectedScenes: UIWindow?
}
