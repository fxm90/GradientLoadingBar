//
//  GradientLoadingBarTests.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 03.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

class GradientLoadingBarTests: XCTestCase {
    var superview: UIView!
    var gradientLoadingBar: GradientLoadingBar!

    override func setUp() {
        super.setUp()

        superview = UIView()
        gradientLoadingBar = GradientLoadingBar(onView: superview)
    }

    override func tearDown() {
        superview = nil
        gradientLoadingBar = nil

        super.tearDown()
    }

    func testInit() {
        XCTAssertEqual(superview.subviews.count, 1)
        XCTAssertEqual(superview.subviews[0], gradientLoadingBar.gradientView)
    }

    func testDeinit() {
        XCTAssertEqual(superview.subviews.count, 1)
        XCTAssertEqual(superview.subviews[0], gradientLoadingBar.gradientView)

        gradientLoadingBar = nil
        XCTAssertEqual(superview.subviews.count, 0)
    }

    func testShow() {
        gradientLoadingBar.show()
        XCTAssertTrue(gradientLoadingBar.isVisible)
        XCTAssertEqual(superview.subviews.count, 1)
    }

    func testHide() {
        gradientLoadingBar.show()
        XCTAssertTrue(gradientLoadingBar.isVisible)
        XCTAssertEqual(superview.subviews.count, 1)

        gradientLoadingBar.hide()
        XCTAssertFalse(gradientLoadingBar.isVisible)
        XCTAssertEqual(superview.subviews.count, 1)
    }

    func testOnlyAddedOnceToSuperview() {
        for _ in 1...100 {
            gradientLoadingBar.show()
            XCTAssertTrue(gradientLoadingBar.isVisible)
            XCTAssertEqual(superview.subviews.count, 1)
        }
    }

    func testToggle() {
        for i in 1...100 {
            gradientLoadingBar.toggle()

            let isVisible = (i % 2) == 1 // Visible on first iteration, after first call to toggle.
            XCTAssertEqual(gradientLoadingBar.isVisible, isVisible)
            XCTAssertEqual(superview.subviews.count, 1)
        }
    }
}
