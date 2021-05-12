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

/// Executes a given closure on it's deallocation.
public final class Disposable {
    // MARK: - Types

    /// Type for closure to be executed on deallocation.
    public typealias Dispose = () -> Void

    // MARK: - Private properties

    /// Closure to be executed on deallocation.
    private let dispose: Dispose

    // MARK: - Initializer

    /// Creates a new instance.
    ///
    /// - Parameter dispose: The closure that is executed on deallocation.
    public init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

    /// Executes our closure.
    deinit {
        dispose()
    }

    // MARK: - Public methods

    /// Adds the current instance to the given array of disposables.
    public func disposed(by bag: inout DisposeBag) {
        bag.append(self)
    }
}
