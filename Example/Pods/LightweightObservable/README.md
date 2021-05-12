![Header][header]

<p align="center">
	<img src="https://img.shields.io/badge/Swift-5.0-green.svg?style=flat" alt="Swift Version" />
	<img src="http://img.shields.io/travis/com/fxm90/LightweightObservable.svg?style=flat" alt="CI Status" />
	<img src="https://img.shields.io/codecov/c/github/fxm90/LightweightObservable.svg?style=flat" alt="Code Coverage" />
	<img src="https://img.shields.io/cocoapods/v/LightweightObservable.svg?style=flat" alt="Version" />
	<img src="https://img.shields.io/cocoapods/l/LightweightObservable.svg?style=flat" alt="License" />
	<img src="https://img.shields.io/cocoapods/p/LightweightObservable.svg?style=flat" alt="Platform" />
</p>

## Features

Lightweight Observable is a simple implementation of an observable sequence that you can subscribe to. The framework is designed to be minimal meanwhile convenient. The entire code is only ~100 lines (excluding comments). With Lightweight Observable you can easily set up UI-Bindings in an MVVM application, handle asynchronous network calls and a lot more.

##### Credits
The code was heavily influenced by [roberthein/observable](https://github.com/roberthein/Observable). However I needed something that was syntactically closer to [RxSwift](https://github.com/ReactiveX/RxSwift), which is why I came up with this code, and for re-usability reasons afterwards moved it into a CocoaPod.

##### Migration Guide
If you want to update from version 1.x.x, please have a look at the [Lightweight Observable 2.0 Migration Guide
](Documentation/Lightweight%20Observable%202.0%20Migration%20Guide.md)

### Example
To run the example project, clone the repo, and open the workspace from the Example directory.

### Requirements
- Swift 5.0
- Xcode 10.2+
- iOS 9.0+

### Integration
##### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Lightweight Observable into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'LightweightObservable', '~> 2.0'
```

##### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate Lightweight Observable into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "fxm90/LightweightObservable" ~> 2.0
```
Run carthage update to build the framework and drag the built `LightweightObservable.framework` into your Xcode project.


##### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but Lightweight Observable does support its use on supported platforms.

Once you have your Swift package set up, adding Lightweight Observable as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/fxm90/LightweightObservable", from: "2.0.0")
]
```


### How to use
The framework provides three classes `Observable`, `PublishSubject` and `Variable`:

 - `Observable`: An observable sequence that you can subscribe to, but not change the underlying value (immutable). This is useful to avoid side-effects on an internal API.
 - `PublishSubject`: Subclass of `Observable` that starts empty and only emits new elements to subscribers (mutable).
 - `Variable`: Subclass of `Observable` that starts with an initial value and replays it or the latest element to new subscribers (mutable).

#### – Create and update a `PublishSubject`
A `PublishSubject` starts empty and only emits new elements to subscribers.

```swift
let userLocationSubject = PublishSubject<CLLocation>()

// ...

userLocationSubject.update(receivedUserLocation)
```

#### – Create and update a `Variable`
A `Variable` starts with an initial value and replays it or the latest element to new subscribers.

```swift
let formattedTimeSubject = Variable("4:20 PM")

// ...

formattedTimeSubject.value = "4:21 PM"
```

#### – Create an `Observable`
Initializing an observable directly is not possible, as this would lead to a sequence that will never change. Instead you need to cast a `PublishSubject` or a `Variable` to an Observable.

```swift
var formattedTime: Observable<String> {
    formattedTimeSubject
}
```
```swift
lazy var formattedTime: Observable<String> = formattedTimeSubject
```

#### – Subscribe to changes
A subscriber will be informed at different times, depending on the corresponding subclass of the observable:

 - `PublishSubject`: Starts empty and only emits new elements to subscribers.
 - `Variable`: Starts with an initial value and replays it or the latest element to new subscribers.

##### – Closure based subscription
**Declaration**

```swift
func subscribe(_ observer: @escaping Observer) -> Disposable
```

Use this method to subscribe to an observable via a closure:

```swift
formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    self?.timeLabel.text = newFormattedTime
}
```

Please notice that the old value (`oldFormattedTime`) is an optional of the underlying type, as we might not have this value on the initial call to the subscriber.

**Important:** To avoid retain cycles and/or crashes, **always** use `[weak self]` when self is needed by an observer.

##### - KeyPath based subscription
**Declaration**

```swift
func bind<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Value>, on object: Root) -> Disposable
```

It is also possible to use Swift's KeyPath feature to bind an observable directly to a property:

```swift
formattedTime.bind(to: \.text, on: timeLabel)
```

#### – Memory Management (`Disposable` / `DisposeBag`)

When you subscribe to an `Observable` the method returns a `Disposable`, which is basically a reference to the new subscription.

We need to maintain it, in order to properly control the life-cycle of that subscription.

Let me explain you why in a little example:

> Imagine having a MVVM application using a service layer for network calls. A service is used as a singleton across the entire app.
>
> The view-model has a reference to a service and subscribes to an observable property of this service. The subscription-closure is now saved inside the observable property on the service.
>
> If the view-model gets deallocated (e.g. due to a dismissed view-controller), without noticing the observable property somehow, the subscription-closure would continue to be alive.
>
> As a workaround, we store the returned disposable from the subscription on the view-model. On deallocation of the disposable, it automatically informs the observable property to remove the referenced subscription closure.

In case you only use a single subscriber you can store the returned `Disposable` to a variable:

```swift
// MARK: - Using `subscribe(_:)`

let disposable = formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    self?.timeLabel.text = newFormattedTime
}

// MARK: - Using a `bind(to:on:)`

let disposable = dateTimeViewModel
    .formattedTime
    .bind(to: \.text, on: timeLabel)
```

In case you're having multiple observers, you can store all returned `Disposable` in an array of `Disposable`. (To match the syntax from [RxSwift](https://github.com/ReactiveX/RxSwift), this pod contains a typealias called `DisposeBag`, which is an array of `Disposable`).

```swift
var disposeBag = DisposeBag()

// MARK: - Using `subscribe(_:)`

formattedTime.subscribe { [weak self] newFormattedTime, oldFormattedTime in
    self?.timeLabel.text = newFormattedTime
}.disposed(by: &disposeBag)

formattedDate.subscribe { [weak self] newFormattedDate, oldFormattedDate in
    self?.dateLabel.text = newFormattedDate
}.disposed(by: &disposeBag)

// MARK: - Using a `bind(to:on:)`

formattedTime
    .bind(to: \.text, on: timeLabel)
    .disposed(by: &disposeBag)

formattedDate
    .bind(to: \.text, on: dateLabel)
    .disposed(by: &disposeBag)
```

A `DisposeBag` is exactly what it says it is, a bag (or array) of disposables.

#### – Observing `Equatable` values
If you create an Observable which underlying type conforms to `Equatable` you can subscribe to changes using a specific filter. Therefore this pod contains the method:

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


#### – Getting the current value synchronously
You can get the current value of the `Observable` by accessing the property `value`. However it is always better to subscribe to a given observable! This **shortcut** should only be used during **testing**.

```swift
XCTAssertEqual(viewModel.formattedTime.value, "4:20")
```

### Sample code
Using the given approach, your view-model could look like this:

```swift
class TimeViewModel {
    // MARK: - Public properties

    /// The current time as a formatted string (**immutable**).
    var formattedTime: Observable<String> {
        formattedTimeSubject
    }

    // MARK: - Private properties

    /// The current time as a formatted string (**mutable**).
    private let formattedTimeSubject: Variable<String> = Variable("\(Date())")

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
    /// subscription-closures from the corresponding observable-properties.
    private var disposeBag = DisposeBag()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        timeViewModel
            .formattedTime
            .bind(to: \.text, on: timeLabel)
            .disposed(by: &disposeBag)
    }
```
Feel free to check out the example application as well for a better understanding of this approach 🙂


### Author
Felix Mau (me(@)felix.hamburg)


### License
LightweightObservable is available under the MIT license. See the LICENSE file for more info.


[header]: Assets/header.png
