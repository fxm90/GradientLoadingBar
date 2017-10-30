//
//  DurationsTests.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 30.10.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import GradientLoadingBar

class DurationsTests: XCTestCase {

    func testInitializer() {
        let fadeIn = 0.1
        let fadeOut = 0.2
        let progress = 0.3

        let durations = Durations(fadeIn: fadeIn, fadeOut: fadeOut, progress: progress)

        XCTAssertEqual(durations.fadeIn, fadeIn)
        XCTAssertEqual(durations.fadeOut, fadeOut)
        XCTAssertEqual(durations.progress, progress)
    }
}
