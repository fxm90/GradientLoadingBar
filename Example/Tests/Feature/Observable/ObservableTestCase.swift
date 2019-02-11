//
//  ObservableTestCase.swift
//  GradientLoadingBar_Tests
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest

@testable import GradientLoadingBar

class ObservableTestCase: XCTestCase {
    // MARK: - Private properties

    private var disposeBag: DisposeBag!

    private var oldValue: Int?
    private var newValue: Int?

    // MARK: - Public methods

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()

        oldValue = nil
        newValue = nil
    }

    override func tearDown() {
        disposeBag = nil

        super.tearDown()
    }

    // MARK: - Test method `observe(:)`

    func testObservableShouldInformObserverWithCorrectValues() {
        // Given
        let variable = Variable(0)

        // When
        variable.asObservable.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.add(to: &disposeBag)

        // Then
        XCTAssertEqual(newValue, 0)
        XCTAssertNil(oldValue)
    }

    func testObservableShouldUpdateObserverWithCorrectValues() {
        // Given
        let variable = Variable(0)

        variable.asObservable.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.add(to: &disposeBag)

        // When
        for value in 1 ..< 10 {
            variable.value = value

            // Then
            XCTAssertEqual(newValue, value)
            XCTAssertEqual(oldValue, value - 1)
        }
    }

    // MARK: - Test method `observe(filter:)`

    func testObservableShouldUpdateObserverOnlyIfFilterMatches() {
        // Given
        let assertNewValueIsEven: (Int, Int?) -> Bool = { newValue, _ in
            newValue.isEven
        }

        let expectation = self.expectation(description: "Expected five even numbers between `0` and `9`.")
        expectation.expectedFulfillmentCount = 5

        let variable = Variable(0)
        variable.asObservable.subscribe(filter: assertNewValueIsEven, observer: { newValue, _ in
            guard newValue.isEven else {
                XCTFail("The received value `\(newValue)` is odd!")
                return
            }

            expectation.fulfill()
        }).add(to: &disposeBag)

        // When
        for value in 1 ..< 10 {
            variable.value = value
        }

        // Then
        waitForExpectations(timeout: 0.1, handler: nil)
    }

    // MARK: - Test method `observeDistinct(:)`

    func testObservableShouldInformDistinctObserverWithCorrectValues() {
        // Given
        let variable = Variable(0)

        // When
        variable.asObservable.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.add(to: &disposeBag)

        // Then
        XCTAssertEqual(newValue, 0)
        XCTAssertNil(oldValue)
    }

    func testObservableShouldUpdateDistinctObserverWithCorrectValues() {
        // Given
        let variable = Variable(0)

        variable.asObservable.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.add(to: &disposeBag)

        // When
        for value in 1 ..< 10 {
            variable.value = value

            // Then
            XCTAssertEqual(newValue, value)
            XCTAssertEqual(oldValue, value - 1)
        }
    }

    func testObservableShouldUpdateDistinctObserverJustOnceForSameValue() {
        // Given
        let expectation = self.expectation(description: "Expected distinct observer to be informed two times: The inital call and the new value.")
        expectation.expectedFulfillmentCount = 2

        let variable = Variable(0)
        variable.asObservable.subscribeDistinct { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue

            expectation.fulfill()
        }.add(to: &disposeBag)

        // When
        for _ in 1 ..< 10 {
            variable.value = 1

            // Then
            XCTAssertEqual(newValue, 1)
            XCTAssertEqual(oldValue, 0)
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    // MARK: - Test deallocated dispose bag

    func testObservableShouldNotInformObserverAfterDeallocatedDisposeBag() {
        // Given
        let variable = Variable(0)

        variable.asObservable.subscribe { newValue, oldValue in
            self.newValue = newValue
            self.oldValue = oldValue
        }.add(to: &disposeBag)

        // When
        disposeBag = nil
        variable.value = 1

        // Then
        XCTAssertEqual(newValue, 0)
        XCTAssertNil(oldValue)
    }
}

// MARK: - Helpers

private extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}
