<p align="center">
    <img src="art/header.png" width="890" alt="Observable"/>
</p>

**Observable** is the easiest way to observe values in Swift.

## How to

### Create an Observable 

```swift
var position = Observable(CGPoint.zero)
```

### Create Observer and ImmutableObserver 

```swift
var position = Observable(CGPoint.zero)
var immutablePosition: ImmutableObservable<CGPoint> = position 
// With an ImmutableObservable the value can't be changed, only read or observe it's value changes
```

### Add an observer

```swift
position.observe { p in
    // handle new position
}
```

### Add an observer and specify the DispatchQueue

```swift
position.observe(DispatchQueue.main) { p in
// handle new position
}
```

### Change the value

```swift
position.value = p
```

## Memory management

For a single observer you can store the returned `Disposable` to a variable

```swift
disposable = position.observe { p in

```

For multiple observers you can add the disposable to a `Disposal` variable

```swift
position.observe { }.add(to: &disposal)
```

And always weakify `self` when referencing `self` inside your observer

```swift
position.observe { [weak self] position in
```

## Installation

### CocoaPods

**Observable** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Observable'
```

### Carthage

**Observable** is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:

```ruby
github "roberthein/Observable" "master"
```

## Suggestions or feedback?

Feel free to create a pull request, open an issue or find [me on Twitter](https://twitter.com/roberthein).
