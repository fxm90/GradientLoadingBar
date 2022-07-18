//
//  Observable+Combine.swift
//  LightweightObservable
//
//  Created by Felix Mau on 04.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Combine

// Based on:
// https://thoughtbot.com/blog/lets-build-a-custom-publisher-in-combine

@available(iOS 13.0, *)
extension Observable: Publisher {

    // MARK: - Types

    public typealias Output = T
    public typealias Failure = Never

    // MARK: - Public methods

    public func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        let subscription = Subscription<S>()
        subscription.subscriber = subscriber

        subscriber.receive(subscription: subscription)

        // We explicitly subscribe to our `Observable` instance after passing the `Combine.Subscription` to the `Combine.Subscriber`.
        // This makes sure when the underlying type of the `Observable` is a `Variable´, we correctly forward the initial value.
        subscription.subscribe(to: self)
    }
}

@available(iOS 13.0, *)
private extension Observable {
    /// A custom subscription to forward events from an `Observable` instance.
    final class Subscription<S: Subscriber> where S.Input == Output, S.Failure == Failure {

        // MARK: - Public properties

        var subscriber: S?

        // MARK: - Private properties

        private var disposable: Disposable?

        // MARK: - Public methods

        /// Updates our `subscriber` (`Combine.Subscriber`) with the values from the observable.
        ///
        /// - Note: We explicitly avoid storing a reference to the observable from this instance (`Combine.Subscription`),
        ///         as this would create a retain cycle!!
        func subscribe(to observable: Observable<S.Input>) {
            disposable = observable.subscribe { [weak self] value, _ in
                _ = self?.subscriber?.receive(value)
            }
        }
    }
}

// MARK: - `Subscription` conformance

@available(iOS 13.0, *)
extension Observable.Subscription: Subscription {
    func request(_: Subscribers.Demand) {
        // This subscription doesn't respond to demand, since it'll only emit events
        // according to its underlying `Observable` instance.
    }

    func cancel() {
        // When the subscription was cancelled, we'll release the reference to our observable-subscription
        // in order to prevent any additional events from being sent.
        disposable = nil
    }
}
