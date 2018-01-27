//
//  GradientLoadingBarViewModelTest.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@testable import GradientLoadingBar
import XCTest

// MARK: - Test case

class GradientLoadingBarViewModelTest: XCTestCase {

    var sharedApplicationMock: SharedApplicationMock!
    var notificationCenter: NotificationCenter!

    var viewModel: GradientLoadingBarViewModel!
    var delegateMock: GradientLoadingBarViewModelDelegateMock!

    override func setUp() {
        super.setUp()

        sharedApplicationMock = SharedApplicationMock()
        notificationCenter = NotificationCenter()

        delegateMock = GradientLoadingBarViewModelDelegateMock()

        viewModel = GradientLoadingBarViewModel(sharedApplication: sharedApplicationMock,
                                                notificationCenter: notificationCenter)
        viewModel.delegate = delegateMock
    }

    override func tearDown() {
        notificationCenter = nil
        sharedApplicationMock = nil

        delegateMock = nil
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Test `keyWindow` did update

    func testSetupObserverForKeyWindowShouldCallDelegateImmediately() {
        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        viewModel.setupObserverForKeyWindow()

        XCTAssertEqual(delegateMock.keyWindow, keyWindow)
    }

    func testSetupObserverForKeyWindowShouldCallDelegateAfterPostNotification() {
        viewModel.setupObserverForKeyWindow()

        XCTAssertNil(delegateMock.keyWindow)

        let keyWindow = UIWindow()
        sharedApplicationMock.keyWindow = keyWindow

        notificationCenter.post(name: .UIWindowDidBecomeKey,
                                object: nil)

        XCTAssertEqual(delegateMock.keyWindow, keyWindow)
    }

    // MARK: - Test visibility methods

    func testShowShouldUpdateVisibility() {
        viewModel.show()

        XCTAssertTrue(delegateMock.isVisible)
        XCTAssertEqual(delegateMock.visiblityCounter, 1)
    }

    func testShowShouldUpdateVisibilityJustOnce() {
        for _ in 1 ... 3 {
            viewModel.show()
        }

        XCTAssertTrue(delegateMock.isVisible)
        XCTAssertEqual(delegateMock.visiblityCounter, 1)
    }

    func testHideShouldUpdateVisibility() {
        viewModel.show()
        viewModel.hide()

        XCTAssertFalse(delegateMock.isVisible)
        XCTAssertEqual(delegateMock.visiblityCounter, 2)
    }

    func testHideShouldUpdateVisibilityJustOnce() {
        viewModel.show()
        for _ in 1 ... 3 {
            viewModel.hide()
        }

        XCTAssertFalse(delegateMock.isVisible)
        XCTAssertEqual(delegateMock.visiblityCounter, 2)
    }

    func testToggleShouldUpdateVisibility() {
        for i in 1 ... 5 {
            viewModel.toggle()

            let isOdd = i % 2 == 1
            XCTAssertEqual(delegateMock.isVisible, isOdd)
            XCTAssertEqual(delegateMock.visiblityCounter, i)
        }
    }
}

// MARK: - Helper: Validate delegate calls

class GradientLoadingBarViewModelDelegateMock: GradientLoadingBarViewModelDelegate {

    private(set) var keyWindow: UIView?

    private(set) var visiblityCounter = 0
    private(set) var isVisible = false {
        didSet {
            visiblityCounter += 1
        }
    }

    func viewModel(_: GradientLoadingBarViewModel, didUpdateKeyWindow keyWindow: UIView) {
        self.keyWindow = keyWindow
    }

    func viewModel(_: GradientLoadingBarViewModel, didUpdateVisibility visible: Bool) {
        isVisible = visible
    }
}

// MARK: - Helper: Mock for `UIApplication`

class SharedApplicationMock: UIApplicationProtocol {
    var keyWindow: UIWindow?
}
