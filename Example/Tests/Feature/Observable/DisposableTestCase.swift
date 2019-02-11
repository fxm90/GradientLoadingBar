//
//  DisposableTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

class DisposableTestCase: XCTestCase {
    func testDisposeClosureShouldNotBeCalledBeforeDeinit() {
        // Given
        let expectation = self.expectation(description: "Expect dispose closure not to be called.")
        expectation.isInverted = true

        var disposable: Disposable?
        disposable = Disposable {
            expectation.fulfill()
        }

        // Workaround to fix warning `Variable 'disposable' was written to, but never read`
        XCTAssertNotNil(disposable, "Precondition failed - Expected to have a valid instance at this point.")

        // When
        // ...

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testDisposeClosureShouldBeCalledOnDeinit() {
        // Given
        let expectation = self.expectation(description: "Expect dispose closure to be called on deinit.")

        var disposable: Disposable?
        disposable = Disposable {
            expectation.fulfill()
        }

        // Workaround to fix warning `Variable 'disposable' was written to, but never read`
        XCTAssertNotNil(disposable, "Precondition failed - Expected to have a valid instance at this point.")

        // When
        disposable = nil

        // Then
        wait(for: [expectation], timeout: 0.1)
    }
}
