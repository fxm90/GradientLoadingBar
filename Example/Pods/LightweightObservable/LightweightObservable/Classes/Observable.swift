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
        fatalError("⚠️ – Subclasses need to overwrite this computed property.")
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
    fileprivate init() {
        // swiftformat:disable:previous redundantFileprivate
    }

    // MARK: - Public methods

    /// Informs the given observer on changes to our `value`.
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

    fileprivate func notifyObserver(_ value: Value, oldValue: OldValue) {
        for (_, observer) in observers {
            observer(value, oldValue)
        }
    }
}

/// Starts empty and only emits new elements to subscribers.
public final class PublishSubject<T>: Observable<T> {
    // MARK: - Public properties

    /// The current (readonly) value of the observable (if available).
    public override var value: Value? {
        currentValue
    }

    // MARK: - Private properties

    /// The storage for our computed property.
    private var currentValue: Value?

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
        let oldValue = currentValue
        currentValue = value

        // We inform the observer here instead of using `didSet` to prevent unwrapping an optional (`currentValue` is nullable, as we're starting empty!).
        notifyObserver(value, oldValue: oldValue)
    }
}

/// Starts with an initial value and replays it or the latest element to new subscribers.
public final class Variable<T>: Observable<T> {
    // MARK: - Public properties

    /// The current (read- and writeable) value of the variable.
    public override var value: Value {
        get {
            currentValue
        }
        set {
            currentValue = newValue
        }
    }

    // MARK: - Private properties

    /// The storage for our computed property.
    private var currentValue: Value {
        didSet {
            notifyObserver(value, oldValue: oldValue)
        }
    }

    // MARK: - Initializer

    /// Initializes a new variable with the given value.
    ///
    /// - Note: We keep the initializer to the super class `Observable` fileprivate in order to verify always having a value.
    public init(_ value: Value) {
        currentValue = value

        super.init()
    }

    // MARK: - Public methods

    public override func subscribe(_ observer: @escaping Observer) -> Disposable {
        // A variable should inform the observer with the initial value.
        observer(value, nil)

        return super.subscribe(observer)
    }
}
