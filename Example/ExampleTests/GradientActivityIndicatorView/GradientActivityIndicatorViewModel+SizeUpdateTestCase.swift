//
//  GradientActivityIndicatorViewModel+SizeUpdateTestCase.swift
//  ExampleTests
//
//  Created by Felix Mau on 18.08.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

// swiftlint:disable:next type_name
final class GradientActivityIndicatorViewModel_SizeUpdateTestCase: XCTestCase {

    // MARK: - Test property `frame`

    func test_frame() {
        // Given
        let bounds = CGRect(x: 0,
                            y: 0,
                            width: .random(in: 0 ... .max),
                            height: .random(in: 0 ... .max))

        // When
        let sizeUpdate = GradientActivityIndicatorViewModel.SizeUpdate(bounds: bounds)

        // Then
        let expectedFrame = CGRect(x: 0,
                                   y: 0,
                                   width: bounds.width * 3,
                                   height: bounds.height)

        XCTAssertEqual(sizeUpdate.frame, expectedFrame)
    }

    // MARK: - Test property `fromValue`

    func test_fromValue() {
        // Given
        let bounds = CGRect(x: 0,
                            y: 0,
                            width: .random(in: 0 ... .max),
                            height: .random(in: 0 ... .max))

        // When
        let sizeUpdate = GradientActivityIndicatorViewModel.SizeUpdate(bounds: bounds)

        // Then
        let expectedFromValue = bounds.width * -2
        XCTAssertEqual(sizeUpdate.fromValue, expectedFromValue)
    }
}
