import Foundation

public class ImmutableObservable<T> {

    public typealias Observer = (T, T?) -> Void

    private var observers: [Int: (Observer, DispatchQueue?)] = [:]
    private var uniqueID = (0...).makeIterator()

    fileprivate let lock: Lock = Mutex()

    fileprivate var _value: T {
        didSet {
            observers.values.forEach { observer, dispatchQueue in
                
                if let dispatchQueue = dispatchQueue {
                    dispatchQueue.async {
                        observer(self.value, oldValue)
                    }
                } else {
                    observer(value, oldValue)
                }
            }
        }
    }

    public var value: T {
        return _value
    }

    public init(_ value: T) {
        self._value = value
    }

    public func observe(_ queue: DispatchQueue? = nil, _ observer: @escaping Observer) -> Disposable {
        lock.lock()
        defer { lock.unlock() }
        
        let id = uniqueID.next()!

        observers[id] = (observer, queue)
        observer(value, nil)

        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
        }

        return disposable
    }

    public func removeAllObservers() {
        observers.removeAll()
    }
}

public class Observable<T>: ImmutableObservable<T> {

    public override var value: T {
        get {
            return _value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _value = newValue
        }
    }
}
