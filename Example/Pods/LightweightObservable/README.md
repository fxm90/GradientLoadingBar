![Header](https://felix.hamburg/files/github/lightweight-observable/header.png)

<p align="center">
	<img src="https://img.shields.io/badge/Swift-5.0-green.svg?style=flat" alt="Swift Version" />
	<img src="http://img.shields.io/travis/com/fxm90/LightweightObservable.svg?style=flat" alt="CI Status" />
	<img src="https://img.shields.io/codecov/c/github/fxm90/LightweightObservable.svg?style=flat" alt="Code Coverage" />
	<img src="https://img.shields.io/cocoapods/v/LightweightObservable.svg?style=flat" alt="Version" />
	<img src="https://img.shields.io/cocoapods/l/LightweightObservable.svg?style=flat" alt="License" />
	<img src="https://img.shields.io/cocoapods/p/LightweightObservable.svg?style=flat" alt="Platform" />
</p>

## Features

Lightweight Obserservable is a simple implementation of an observable sequence that you can subscribe to. The framework is designed to be minimal meanwhile convenient. The entire code is only ~80 lines (excluding comments). With Lightweight Observable you can easily set up UI-Bindings in an MVVM application, handle asynchronous network calls and a lot more.

**Credits:** The code was heavily influenced by [roberthein/observable](https://github.com/roberthein/Observable). However I needed something that was syntactically closer to [RxSwift](https://github.com/ReactiveX/RxSwift), which is why I came up with this code, and for reusability reasons afterwards moved it into a CocoaPod.

### Example
To run the example project, clone the repo, and open the workspace from the Example directory.

### Integration
##### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Lightweight Observable into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
pod 'LightweightObservable', '~> 1.0'
```

##### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Lightweight Observable into your Xcode project using Carthage, specify it in your `Cartfile`:
```ogdl
github "fxm90/LightweightObservable" ~> 1.0
```
Run carthage update to build the framework and drag the built `LightweightObservable.framework` into your Xcode project.


##### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Lightweight Observable does support its use on supported platforms.

Once you have your Swift package set up, adding Lightweight Observable as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.
```swift
dependencies: [
    .package(url: "https://github.com/fxm90/LightweightObservable", from: "1.0.3")
]
```


### How to use
The framework provides two classes `Observable` and `Variable`:
 - `Observable`: Contains an immutable value, you only can subscribe to. This is useful in order to avoid side-effects on an internal API.
 - `Variable`: Subclass of `Observable`, where you can modify the value as well.

Using the given approach, your view-model could look like this:
```swift
class TimeViewModel {
    // MARK: - Public properties

    /// The current time as a formatted string (**immutable**).
    var formattedTime: Observable<String> {
        return formattedTimeSubject.asObservable
    }

    // MARK: - Private properties

    /// The current time as a formatted string (**mutable**).
    private let formattedTimeSubject: Variable<String> = Variable("")

    private var timer: Timer?

    // MARK: - Initializer

    init() {
        // Update variable with current time every second.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            self?.formattedTimeSubject.value = "\(Date())"
        })
    }
```

And your view controller like this:
```swift
class TimeViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var timeLabel: UILabel!

    // MARK: - Private properties

    /// The view model calculating the current time.
    private let timeViewModel = TimeViewModel()

    /// The dispose bag for this view controller. On it's deallocation, it removes the
    /// subscribtion-closures from the corresponding observable-properties.
    private var disposeBag = DisposeBag()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        timeViewModel.formattedTime.subscribe { [weak self] newFormattedTime, _ in
            self?.timeLabel.text = newFormattedTime
        }.disposed(by: &disposeBag)
    }
```

Feel free to check out the example application for a better understanding of this approach 🙂

#### Further details

#### – Create and update variable
```swift
let formattedTimeSubject = Variable("")

// ...

formattedTimeSubject.value = "4:20 PM"
```

#### – Create an observable
Initializing an observable directly is not possible, as this would lead to a sequence that will never change. Instead, use the computed property `asObservable` from `Variable` to cast the instance to an observable.
```swift
var formattedTime: Observable<String> {
    return formattedTimeSubject.asObservable
}
```

#### – Subscribe to changes
Every subscriber gets initialized with the current value and updated on all further changes to the observable value.

```swift
formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    self?.timeLabel.text = newFormattedTime
}
```

Please notice that the old value (`oldFormattedTime`) is an optional of the underlying type, as we don't have this value on the initial call to the subscriber.

**Important:** To avoid retain cycles and/or crashes, **always** use `[weak self]` when self is needed by an observer.

#### – Memory Management (`Disposable` / `DisposeBag`)

When you subscribe to an `Observable` the method returns a `Disposable`, which is basically a reference to the new subscription.

We need to maintain it, in order to properly control the lifecycle of that subscription.

Let me explain you why in a little example:

> Imagine having a MVVM application using a service layer for network calls. A service is used as a singleton across the entire app.
>
> The view-model has a reference to a service and subscribes to an observable property. The subscription-closure is now saved inside the observable property on the service.
>
> If the view-model gets deallocated (e.g. due to a dismissed view-controller), without noticing the observable property somehow, the subscription-closure would continue to be alive.
>
> As a workaround, we store the returned disposable from the subscription on the view-model. On deallocation of the disposable, it automatically informs the observable property to remove the referenced subscription closure.

In case you only use a single subscriber you can store the returned `Disposable` to a variable:
```swift
let disposable = formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
	// ...
}
```

In case you're having multiple observers, you can store all returned `Disposable` in an array of `Disposable`. (To match the syntax from [RxSwift](https://github.com/ReactiveX/RxSwift), this pod contains a typealias called `DisposeBag`, which is an array of `Disposable`).
```swift
var disposeBag = DisposeBag()

formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    // ...
}.disposed(by: &disposeBag)

formattedDate.subscribe { [weak self] newFormattedDate, oldFormattedDate in
    // ...
}.disposed(by: &disposeBag)
```

A `DisposeBag` is exactly what it says it is, a bag (or array) of disposables.

#### – Observing `Equatable` values
If you create an Observable which underlying type conforms to `Equtable` you can subscribe to changes using a specific filter. Therefore this pod contains the method:
```swift
typealias Filter = (NewValue, OldValue) -> Bool

func subscribe(filter: @escaping Filter, observer: @escaping Observer) -> Disposable {}
```

Using this method, the observer will only be notified on changes if the corresponding filter matches.

This pod comes with one predefined filter method, called `subscribeDistinct`. Subscribing to an observable using this method, will only notify the observer if the new value is different from the old value. This is useful to prevent unnecessary UI-Updates.

Feel free to add more filters, by extending the `Observable` like this:
```swift
extension Observable where T: Equatable {}
```

### Author

Felix Mau (me(@)felix.hamburg)

### License

LightweightObservable is available under the MIT license. See the LICENSE file for more info.
