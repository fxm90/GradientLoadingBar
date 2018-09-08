//
//  Observable+ObserveDistinct.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 25.08.18.
//

import Foundation
import Observable

extension Observable where T: Equatable {
    /// A wrapper around the `observe` method, that checks whether the previous value is different from the next value.
    /// If they are equal the listener will not be notified. This is useful to prevent unnecessary UI updates.
    public func observeDistinct(_ observer: @escaping Observer) -> Disposable {
        return observe({ nextValue, prevValue in
            guard nextValue != prevValue else { return }

            observer(nextValue, prevValue)
        })
    }
}
