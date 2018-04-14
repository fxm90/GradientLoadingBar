//
//  DurationsTests.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 30.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@testable import GradientLoadingBar
import XCTest

class DurationsTests: XCTestCase {
    func testInitializer() {
        let fadeIn = 0.1
        let fadeOut = 0.2
        let progress = 0.3

        let animationDurations = Durations(fadeIn: fadeIn, fadeOut: fadeOut, progress: progress)

        XCTAssertEqual(animationDurations.fadeIn, fadeIn)
        XCTAssertEqual(animationDurations.fadeOut, fadeOut)
        XCTAssertEqual(animationDurations.progress, progress)
    }
}
