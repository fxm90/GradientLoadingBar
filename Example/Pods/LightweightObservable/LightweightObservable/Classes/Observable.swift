//
//  Observable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// A lightweight implementation of an observable sequence that you can subscribe to.
///
/// - Note: Partly based on [roberthein/Observable](https://github.com/roberthein/Observable).
///
/// - Remark: I'd prefer having a protocol definition here, but casting an instance with a generic (e.g. `Variable<Int>(0)`) to a protocol
///           with an associated type (`Observable<Int>`) doesn't work yet. Therefore we use an "abstract" class as a workaround.
public class Observable<T> {
    // MARK: - Types

    /// The type for the new value of the observable.
    public typealias Value = T

    /// The type for the previous value of the observable.
    public typealias OldValue = T?

    /// The type for the closure to executed on change of the observable.
    ///
    /// - Parameters:
    ///   - value: The current (new) value.
    ///   - oldValue: The previous (old) value.
    public typealias Observer = (_ value: Value, _ oldValue: OldValue) -> Void

    /// We store all observers within a dictionary, for which this is the type of the key.
    private typealias Index = UInt

    // MARK: - Public properties

    /// The current (readonly) value of the observable (if available).
    ///
    /// - Note: We're using a computed property here, cause we need to override this property without nullability in the subclass `Variable`.
    ///
    /// - Attention: It's always better to subscribe to a given observable! This **shortcut** should only be used during **testing**.
    public var value: Value? {
        fatalError("⚠️ – Trying to access an abstract property! Subclasses need to overwrite and implement this computed property.")
    }

    // MARK: - Private properties

    /// The index of the last inserted observer.
    private var lastIndex: Index = 0

    /// Map with all **active** observers.
    private var observers = [Index: Observer]()

    // MARK: - Initalizer

    /// Initializes a new observable.
    ///
    /// - Note: Declared `fileprivate` in order to prevent directly initializing an observable, that can't emit values.
    fileprivate init() {}

    // MARK: - Public methods

    /// Informs the given observer on changes to our underlying property `value`.
    ///
    /// - Parameter observer: The closure that is notified on changes.
    public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let indexForNewObserver = lastIndex + 1
        observers[indexForNewObserver] = observer
        lastIndex = indexForNewObserver

        // Return a disposable, that removes the entry for this observer on it's deallocation.
        return Disposable { [weak self] in
            self?.observers[indexForNewObserver] = nil
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
    override public var value: Value? {
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
    override public init() {
        super.init()
    }

    // MARK: - Public methods

    /// Updates the publish subject using the given value.
    public func update(_ value: Value) {
        let oldValue = _value
        _value = value

        // We inform the observer here instead of using `didSet` on `_value` to prevent unwrapping an optional (`_value` is nullable, as we're starting empty).
        // Unwrapping lead to issues / crashes on having an underlying optional type, e.g. `PublishSubject<Int?>`.
        notifyObserver(with: value, from: oldValue)
    }
}

/// Starts with an initial value and replays it or the latest element to new subscribers.
public final class Variable<T>: Observable<T> {
    // MARK: - Public properties

    /// The current (read- and writeable) value of the variable.
    override public var value: Value {
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

    override public func subscribe(_ observer: @escaping Observer) -> Disposable {
        let disposable = super.subscribe(observer)

        // A variable should inform the observer with the initial value.
        observer(_value, nil)

        return disposable
    }
}
