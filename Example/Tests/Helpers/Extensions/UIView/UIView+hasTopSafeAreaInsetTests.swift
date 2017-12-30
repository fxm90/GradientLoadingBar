//
//  UIView+hasTopSafeAreaInsetTests.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

// MARK: - Test case

@available(iOS, introduced: 11.0, message: "iOS 11.0 is required for this test case")
class UIViewHasTopSafeAreaInsetTests: XCTestCase {

    func testHasTopSafeAreaInsetTestsShouldReturnTrue() {
        let safeAreaView = SafeAreaViewMock(frame: .zero)
        safeAreaView.safeAreaInsets = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 0.0)

        XCTAssertTrue(safeAreaView.hasTopSafeAreaInset)
    }

    func testHasTopSafeAreaInsetTestsShouldReturnFalse() {
        let safeAreaView = SafeAreaViewMock(frame: .zero)
        safeAreaView.safeAreaInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right: 1.0)

        XCTAssertFalse(safeAreaView.hasTopSafeAreaInset)
    }
}

// MARK: - Helper: Create UIView with `safeAreaInsets` programmatically

@available(iOS, introduced: 11.0, message: "iOS 11.0 is required for this test case")
private class SafeAreaViewMock: UIView {
    private var customSafeAreaInsets: UIEdgeInsets?

    override var safeAreaInsets: UIEdgeInsets {
        get {
            guard let customSafeAreaInsets = customSafeAreaInsets else {
                return super.safeAreaInsets
            }

            return customSafeAreaInsets
        }

        set {
            customSafeAreaInsets = newValue
        }
    }
}
