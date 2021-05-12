//
//  Observable+Equatable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 01.05.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// Additional helper methods for an observable that that underlying type conforms to `Equatable`.
public extension Observable where T: Equatable {
    // MARK: - Types

    /// The type for the filter closure.
    ///
    /// - Parameters:
    ///   - value: The current (new) value.
    ///   - oldValue: The previous (old) value.
    ///
    /// - Returns: `true` if the filter matches, otherwise `false`.
    typealias Filter = (_ value: Value, _ oldValue: OldValue) -> Bool

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`, only if the given filter matches.
    ///
    /// - Parameters:
    ///   - filter: The closure, that must return `true` in order for the observer to be notified.
    ///   - observer: The closure that is notified on changes if the filter succeeds.
    ///
    ///  - Note:
    ///   The `oldValue` of the observer always contains the previous value that passed the filter! E.g. if you filter for even numbers:
    ///   ```
    ///   | Emitted values:            | 0        | 1        | 2        | 3        | 4        | 5        |
    ///   | -------------------------- | -------- | -------- | -------- | -------- | -------- | -------- |
    ///   | filter(value, oldValue):   | (0, nil) | (1, 0)   | (2, 1)   | (3, 2)   | (4, 3)   | (5, 4)   |
    ///   | result:                    | true     | false    | true     | false    | true     | false    |
    ///   | observer(value, oldValue): | (0, nil) |          | (2, 0)   |          | (4, 2)   |          |
    ///   ```
    func subscribe(filter: @escaping Filter, observer: @escaping Observer) -> Disposable {
        // As we're only calling the observer after the given `filter` succeeds, we need to save the last `newValue` that passed the filter.
        // Then we can pass this value as the correct `oldValue` on the next call to the given `observer`.
        var filteredOldValue: OldValue = nil

        return subscribe { newValue, oldValue in
            // For having a correct working filter we need to pass in the current `oldValue`.
            if filter(newValue, oldValue) {
                observer(newValue, filteredOldValue)
                filteredOldValue = newValue
            }
        }
    }

    /// Informs the given observer on **distinct** changes to our `value`.
    ///
    /// - Parameter observer: The closure that is notified on changes.
    func subscribeDistinct(_ observer: @escaping Observer) -> Disposable {
        subscribe(filter: { $0 != $1 },
                  observer: observer)
    }
}
