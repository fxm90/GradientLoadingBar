//
//  Disposable.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 11/02/19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

// Source
// https://gist.github.com/fxm90/26357043cfe174fabdeedd07d0f25314

/// Helper to allow storing multiple disposables (and matching name from RxSwift).
typealias DisposeBag = [Disposable]

final class Disposable {
    // MARK: - Types

    typealias Dispose = () -> Void

    // MARK: - Private properties

    private let dispose: Dispose

    // MARK: - Initializer

    init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    // MARK: - Public methods

    func add(to disposeBag: inout DisposeBag) {
        disposeBag.append(self)
    }
}
