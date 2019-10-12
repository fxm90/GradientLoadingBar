//
//  Observable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// An observable sequence that you can subscribe to. Any of the subscriber will receive the most
/// recent element and everything that is emitted by that sequence after the subscription happened.
///
/// - Note: Implementation based on [roberthein/Observable](https://github.com/roberthein/Observable).
public class Observable<T> {
    // MARK: - Types

    /// The type for the new value of the observable.
    public typealias NewValue = T

    /// The type for the previous value of the observable.
    public typealias OldValue = T?

    /// The type for the closure to executed on change of the observable.
    public typealias Observer = (NewValue, OldValue) -> Void

    /// We store all observers within a dictionary, for which this is the type of the key.
    private typealias Index = UInt

    // MARK: - Public properties

    /// The current (readonly) value of the observable.
    public fileprivate(set) var value: T {
        didSet {
            for (_, observer) in observers {
                observer(value, oldValue)
            }
        }
    }

    // MARK: - Private properties

    /// The index of the last inserted observer.
    private var lastIndex: Index = 0

    /// Map with all active observers.
    private var observers = [Index: Observer]()

    // MARK: - Initalizer

    /// Initializes a new observable with the given value.
    ///
    /// - Note: Declared `fileprivate` in order to prevent directly initializing an observable, which can not be updated.
    fileprivate init(_ value: T) {
        // swiftformat:disable:previous redundantFileprivate
        self.value = value
    }

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`.
    ///
    /// - Parameter observer: The observer-closure that is notified on changes.
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let currentIndex = lastIndex + 1
        observers[currentIndex] = observer

        lastIndex = currentIndex

        // Inform observer with initial value.
        observer(value, nil)

        // Return a disposable, that removes the entry for this observer on it's deallocation.
        return Disposable { [weak self] in
            self?.observers[currentIndex] = nil
        }
    }
}

/// A special form of an observable sequence, that you can subscribe to AND dynamically add elements.
///
/// - Note: Has to be declared in the same file as `Observable`, to overwrite `fileprivate` setter for property `value`.
///         (Workaround for a "protected" property).
public final class Variable<T>: Observable<T> {
    // MARK: - Public properties

    /// The current variable converted to an (readonly) `Observable`.
    public var asObservable: Observable<T> {
        return self as Observable
    }

    /// The current value of the observable.
    public override var value: T {
        get {
            return super.value
        }
        set {
            super.value = newValue
        }
    }

    // MARK: - Initializer

    /// Initializes a new variable with the given value.
    ///
    /// - Note: As we've made the initializer to the super class `Observable` fileprivate, we must override it here with public access.
    public override init(_ value: T) {
        super.init(value)
    }
}
