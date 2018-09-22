GradientLoadingBar
====================

![Swift4.2](https://img.shields.io/badge/Swift-4.2-green.svg?style=flat) [![CI Status](http://img.shields.io/travis/fxm90/GradientLoadingBar.svg?style=flat)](https://travis-ci.org/fxm90/GradientLoadingBar) [![Version](https://img.shields.io/cocoapods/v/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar) [![License](https://img.shields.io/cocoapods/l/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar) [![Platform](https://img.shields.io/cocoapods/p/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar)

### Example
A customizable animated gradient loading bar. Inspired by [iOS 7 Progress Bar from Codepen](https://codepen.io/marcobiedermann/pen/LExXWW).

![Example](http://felix.hamburg/files/github/gradient-loading-bar/screen.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Integration
##### CocoaPods
GradientLoadingBar can be added to your project using [CocoaPods](https://cocoapods.org/) by adding the following line to your Podfile:
```
pod 'GradientLoadingBar', '~> 1.0'
```
##### Carthage
To integrate GradientLoadingBar into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:
```
github "fxm90/GradientLoadingBar" ~> 1.0
```
Run carthage update to build the framework and drag the built `GradientLoadingBar.framework` (as well as the dependency [`Observable.framework`](https://github.com/roberthein/Observable)) into your Xcode project.

### How to use
To get started you'll have to import `GradientLoadingBar` into your file. To show the loading bar, simply call the `show()` method and after you're done with your operations call `hide()`.
```swift
let gradientLoadingBar = GradientLoadingBar()
gradientLoadingBar.show()

// Do e.g. server calls etc.

// Be sure to call this on the main thread.
gradientLoadingBar.hide()
```
### Configuration
You can overwrite the default configuration by calling the initializers with the optional parameters `height`, `durations`, `gradientColorList`, `isRelativeToSafeArea` and `onView`:
```swift
let gradientLoadingBar = GradientLoadingBar(
    height: 3.0,
    durations: Durations(fadeIn: 1.5, 
                         fadeOut: 2.0, 
                         progress: 2.5)
    gradientColorList: [
        .red, .yellow, .green
    ],
    isRelativeToSafeArea: true,
    onView: self.view
)
```

#### – Parameter `height`
By setting this parameter you can set the height for the loading bar (defaults to `2.5`)

#### – Parameter `durations`
By setting this parameter you set the durations (fade-in, fade-out, progress) for the loading bar.

To customize these, you have to pass in an instance of the struct `Durations`, which has the following initializer:
`public init(fadeIn: Double = 0.0, fadeOut: Double = 0.0, progress: Double = 0.0)`

These are the default duration values: 
`public static let default = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)`

#### – Parameter `gradientColorList`
The gradient colors are fully customizable. Do do this, you'll have to pass an array of type `UIColor`.

#### – Parameter `isRelativeToSafeArea`
With this parameter you can configure, whether the loading bar should be positioned relative to the safe area (defaults to `true`).

Example with `isRelativeToSafeArea` set to `true`
[![Example][basic-example--thumbnail]][basic-example]


Example with `isRelativeToSafeArea` set to `false`
[![Example][safe-area-example--thumbnail]][safe-area-example]


#### – Parameter `onView` 
With this parameter you can pass a custom superview to the gradient loading bar.

E.g. Loading bar shown on `UINavigationBar`
[![Example][navigation-bar-example--thumbnail]][navigation-bar-example]

E.g. Loading bar shown on `UIButton`
[![Example][advanced-example--thumbnail]][advanced-example]

To see all these configurations in a real app, please have a look at the **example application**. For further customization you can also subclass `GradientLoadingBar` and overwrite the method `setupConstraints()`. This is also done for showing the loading bar at the bottom of the `UINavigationBar`. Therefore, this module contains furthermore the class `BottomGradientLoadingBar`, which basically just overwrites the method `setupConstraints()`.


#### – Custom shared instance (Singleton)
If you need the loading bar on different parts of your app, you can use the given static `shared` variable:
```swift
GradientLoadingBar.shared.show()

// Do e.g. server calls etc.

GradientLoadingBar.shared.hide()
```
If you wish to customize the shared instance, you can add the following code e.g. to your app delegate `didFinishLaunchingWithOptions` method and overwrite the `shared` variable:
```swift
GradientLoadingBar.shared = GradientLoadingBar(
    height: 3.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.00),
    gradientColorList: [
        .red, .yellow, .green
    ]
)
```

### Usage with PromiseKit
Check out [my GitHub Gist](https://gist.github.com/fxm90/698554e8335f34e0c6ab95194a4678fb) on how to easily use GradientLoadingBar with [PromiseKit](http://promisekit.org/).

### Author
Felix Mau (contact(@)felix.hamburg)

### License

GradientLoadingBar is available under the MIT license. See the LICENSE file for more info.

[basic-example]: https://felix.hamburg/files/github/gradient-loading-bar/basic-example.jpg
[basic-example--thumbnail]: https://felix.hamburg/files/github/gradient-loading-bar/basic-example--thumbnail.png

[safe-area-example]: https://felix.hamburg/files/github/gradient-loading-bar/safe-area-example.jpg
[safe-area-example--thumbnail]: https://felix.hamburg/files/github/gradient-loading-bar/safe-area-example--thumbnail.png

[advanced-example]: https://felix.hamburg/files/github/gradient-loading-bar/advanced-example.jpg
[advanced-example--thumbnail]: https://felix.hamburg/files/github/gradient-loading-bar/advanced-example--thumbnail.png

[navigation-bar-example]: https://felix.hamburg/files/github/gradient-loading-bar/navigation-bar-example.jpg
[navigation-bar-example--thumbnail]: https://felix.hamburg/files/github/gradient-loading-bar/navigation-bar-example--thumbnail.png
