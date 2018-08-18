import Foundation

public typealias Disposal = [Disposable]

public final class Disposable {
    private let dispose: () -> Void

    init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    public func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
