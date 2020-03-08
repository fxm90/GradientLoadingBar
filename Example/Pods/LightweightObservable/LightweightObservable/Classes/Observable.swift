//
//  Observable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// An observable sequence that you can subscribe to.
///
/// - Note: Implementation is partly based on [roberthein/Observable](https://github.com/roberthein/Observable).
///
/// - Remark: I'd prefer having a protocol definition here, but casting an instance with a generic (e.g. `Variable<Int>(0)`) to a
///           protocol with an associated type (`Observable<Int>`) does not work. Therefore we use an "abstract" class as a workaround.
public class Observable<T> {
    // MARK: - Types

    /// The type for the new value of the observable.
    public typealias Value = T

    /// The type for the previous value of the observable.
    public typealias OldValue = T?

    /// The type for the closure to executed on change of the observable.
    public typealias Observer = (Value, OldValue) -> Void

    /// We store all observers within a dictionary, for which this is the type of the key.
    private typealias Index = UInt

    // MARK: - Public properties

    /// The current (readonly) value of the observable (if available).
    ///
    /// - Note: We're using a computed property here, cause we need to override this property without nullability in the subclass `Variable`.
    ///
    /// - Attention: It's always better to subscribe to a given observable! This **shortcut** should only be used during **testing**.
    public var value: Value? {
        fatalError("⚠️ – Subclasses need to overwrite and implement this computed property.")
    }

    // MARK: - Private properties

    /// The index of the last inserted observer.
    private var lastIndex: Index = 0

    /// Map with all active observers.
    private var observers = [Index: Observer]()

    // MARK: - Initalizer

    /// Initializes a new observable.
    ///
    /// - Note: Declared `fileprivate` in order to prevent directly initializing an observable, which can not be updated.
    fileprivate init() {}

    // MARK: - Public methods

    /// Informs the given observer on changes to our property `value`.
    ///
    /// - Parameter observer: The observer-closure that is notified on changes.
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let currentIndex = lastIndex + 1
        observers[currentIndex] = observer
        lastIndex = currentIndex

        // Return a disposable, that removes the entry for this observer on it's deallocation.
        return Disposable { [weak self] in
            self?.observers[currentIndex] = nil
        }
    }

    // MARK: - Private methods

    fileprivate func notifyObserver(with value: Value, from oldValue: OldValue) {
        observers.values.forEach { observer in
            observer(value, oldValue)
        }
    }
}

/// Starts empty and only emits new elements to subscribers.
public final class PublishSubject<T>: Observable<T> {
    // MARK: - Public properties

    /// The current (readonly) value of the observable (if available).
    public override var value: Value? {
        _value
    }

    // MARK: - Private properties

    /// The storage for our computed property.
    ///
    /// - Note: Workaround for compiler error `Cannot override with a stored property 'value'`.
    private var _value: Value?

    // MARK: - Initializer

    /// Initializes a new publish subject.
    ///
    /// - Note: As we've made the initializer to the super class `Observable` fileprivate, we must override it here to allow public access.
    public override init() {
        super.init()
    }

    // MARK: - Public methods

    /// Updates the publish subject using the given value.
    public func update(_ value: Value) {
        let oldValue = _value
        _value = value

        // We inform the observer here instead of using `didSet` on `_value` to prevent unwrapping an optional (`_value` is nullable, as we're starting empty!).
        // Unwrapping lead to issues on having an underlying optional type.
        notifyObserver(with: value, from: oldValue)
    }
}

/// Starts with an initial value and replays it or the latest element to new subscribers.
public final class Variable<T>: Observable<T> {
    // MARK: - Public properties

    /// The current (read- and writeable) value of the variable.
    public override var value: Value {
        get { _value }
        set { _value = newValue }
    }

    // MARK: - Private properties

    /// The storage for our computed property.
    ///
    /// - Note: Workaround for compiler error `Cannot override with a stored property 'value'`.
    private var _value: Value {
        didSet {
            notifyObserver(with: value, from: oldValue)
        }
    }

    // MARK: - Initializer

    /// Initializes a new variable with the given value.
    ///
    /// - Note: We keep the initializer to the super class `Observable` fileprivate in order to verify always having a value.
    public init(_ value: Value) {
        _value = value

        super.init()
    }

    // MARK: - Public methods

    public override func subscribe(_ observer: @escaping Observer) -> Disposable {
        // A variable should inform the observer with the initial value.
        observer(_value, nil)

        return super.subscribe(observer)
    }
}
