//
//  Disposable.swift
//  LightweightObservable
//
//  Created by Felix Mau on 11.02.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

/// Helper to allow storing multiple disposables and matching name from [RxSwift](https://github.com/ReactiveX/RxSwift).
public typealias DisposeBag = [Disposable]

/// Invokes a closure when this instance is deallocated.
public final class Disposable {

    // MARK: - Types

    /// Type for the closure to be called on deallocation.
    public typealias Dispose = () -> Void

    // MARK: - Private properties

    /// The closure to be called on deallocation.
    private let dispose: Dispose

    // MARK: - Instance Lifecycle

    /// Creates a new instance.
    ///
    /// - Parameter dispose: The closure that is called on deallocation.
    public init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    // MARK: - Public methods

    /// Adds the current instance to the given array of `Disposable`.
    ///
    /// - Parameter bag: Reference to the array of `Disposable`.
    public func disposed(by bag: inout DisposeBag) {
        bag.append(self)
    }
}
