//
//  UIView+hasTopSafeAreaInsetTests.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

class UIViewHasTopSafeAreaInsetTests: XCTestCase {

    @available(iOS, introduced: 11.0, message: "iOS 11.0 is required for this test case")
    func testHasTopSafeAreaInsetTestsShouldReturnTrue() {
        let view = SafeAreaView(insets: UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 0.0))
        XCTAssertTrue(view.hasTopSafeAreaInset)
    }

    @available(iOS, introduced: 11.0, message: "iOS 11.0 is required for this test case")
    func testHasTopSafeAreaInsetTestsShouldReturnFalse() {
        let view = SafeAreaView(insets: UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right: 1.0))
        XCTAssertFalse(view.hasTopSafeAreaInset)
    }
}

// MARK: - Helper

private class SafeAreaView: UIView {
    let insets: UIEdgeInsets

    init(insets: UIEdgeInsets) {
        self.insets = insets

        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var safeAreaInsets: UIEdgeInsets {
        return insets
    }
}
