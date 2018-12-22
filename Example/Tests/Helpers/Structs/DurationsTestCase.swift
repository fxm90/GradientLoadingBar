//
//  DurationsTestCase.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 10/30/17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

class DurationsTestCase: XCTestCase {
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
