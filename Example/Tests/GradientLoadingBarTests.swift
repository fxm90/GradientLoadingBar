//
//  GradientLoadingBarTests.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 03.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@testable import GradientLoadingBar
import XCTest

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

    // MARK: - Test initializer

    func testInit() {
        XCTAssertEqual(superview.subviews.count, 1)
        XCTAssertEqual(superview.subviews.first, gradientLoadingBar.gradientView)
    }

    func testDeinit() {
        XCTAssertEqual(superview.subviews.count, 1)
        XCTAssertEqual(superview.subviews.first, gradientLoadingBar.gradientView)

        gradientLoadingBar = nil
        XCTAssertEqual(superview.subviews.count, 0)
    }

    // MARK: - Test visibility methods

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

    func testToggle() {
        for i in 1 ... 100 {
            gradientLoadingBar.toggle()

            // Visible on first iteration, after first call to toggle.
            let isVisible = (i % 2) == 1

            XCTAssertEqual(gradientLoadingBar.isVisible, isVisible)
            XCTAssertEqual(superview.subviews.count, 1)
        }
    }
}
