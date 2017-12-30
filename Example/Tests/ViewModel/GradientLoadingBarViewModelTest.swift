//
//  GradientLoadingBarViewModelTest.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

// MARK: - Test case

class GradientLoadingBarViewModelTest: XCTestCase {
    var viewModel: GradientLoadingBarViewModel!
    var delegateMock: GradientLoadingBarViewModelDelegateMock!

    override func setUp() {
        super.setUp()

        delegateMock = GradientLoadingBarViewModelDelegateMock()

        viewModel = GradientLoadingBarViewModel()
        viewModel.delegate = delegateMock
    }

    override func tearDown() {
        delegateMock = nil
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Test `show()`

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

    // MARK: - Test `hide()`

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

    // MARK: - Test `toggle()`

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
    private(set) var visiblityCounter = 0

    private(set) var isVisible = false {
        didSet {
            visiblityCounter += 1
        }
    }

    func viewModel(_ viewModel: GradientLoadingBarViewModel, didUpdateVisibility visible: Bool) {
        isVisible = visible
    }
}
