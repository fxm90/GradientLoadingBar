//
//  GradientLoadingBarViewModelTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest
import LightweightObservable

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

    func test_initializer_shouldSetupSuperviewObservable_withNil() throws {
        // When
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        // Then
        let variable = try XCTUnwrap(viewModel.superview as? Variable, "Cast `Observable` instance to `Variable` in order to validate the initial value.")
        XCTAssertNil(variable.value)
    }

    func test_initializer_shouldSetupSuperviewObservable_withKeyWindow() {
        // Given
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindowInConnectedScenes = keyWindow

        // When
        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        // Then
        XCTAssertEqual(viewModel.superview.value, keyWindow)
    }

    func test_initializer_shouldSetupSuperviewObservable_afterUIWindowDidBecomeKeyNotification() {
        // Given
        sharedApplicationMock.keyWindowInConnectedScenes = nil

        let viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                    notificationCenter: notificationCenter)

        // When
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindowInConnectedScenes = keyWindow

        notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                object: nil)

        // Then
        XCTAssertEqual(viewModel.superview.value, keyWindow)
    }

    func test_deinit_shouldResetSuperviewObservable_withNil() {
        // Given
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindowInConnectedScenes = keyWindow

        var viewModel: GradientLoadingBarViewModel? = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                                                  notificationCenter: notificationCenter)

        let expectation = expectation(description: "Expected observer to be informed to reset superview to nil.")
        var disposeBag = DisposeBag()

        // As we've just initialized the view model it has to exist at this point, and therefore we can "safely" use force-unwrapping here.
        // swiftlint:disable:next force_unwrapping
        viewModel!.superview.subscribe { newSuperview, _ in
            guard newSuperview == nil else {
                // Skip initial call to observer.
                return
            }

            expectation.fulfill()
        }.disposed(by: &disposeBag)

        // When
        viewModel = nil

        // Then
        wait(for: [expectation], timeout: 0.1)
    }
}

// MARK: - Mocks

private final class SharedApplicationMock: UIApplicationProtocol {
    var keyWindowInConnectedScenes: UIWindow?
}
