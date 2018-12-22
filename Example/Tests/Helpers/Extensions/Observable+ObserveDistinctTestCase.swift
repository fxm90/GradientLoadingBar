//
//  Observable+ObserveDistinctTestCase.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/25/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import XCTest
import Observable

class ObservableObserveDistinctTestCase: XCTestCase {
    func testObserveDistinctShouldNotifyListener() {
        // Given
        let prevValue = 123
        let nextValue = 456

        let observable = Observable(prevValue)

        var observeCallCounter = 0

        var disposeBag = Disposal()
        observable.observeDistinct { _, _ in
            observeCallCounter += 1
        }.add(to: &disposeBag)

        // When
        observable.value = nextValue

        // Then
        XCTAssertEqual(observeCallCounter, 2)
    }

    func testObserveDistinctShouldNotNotifyListenerDueToSameValue() {
        // Given
        let prevValue = 123
        let nextValue = 123

        let observable = Observable(prevValue)

        var observeCallCounter = 0

        var disposeBag = Disposal()
        observable.observeDistinct { _, _ in
            observeCallCounter += 1
        }.add(to: &disposeBag)

        // When
        observable.value = nextValue

        // Then
        XCTAssertEqual(observeCallCounter, 1)
    }
}
