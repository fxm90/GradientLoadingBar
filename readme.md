GradientLoadingBar
====================

![Swift4.0](https://img.shields.io/badge/Swift-4.0-green.svg?style=flat) [![CI Status](http://img.shields.io/travis/fxm90/GradientLoadingBar.svg?style=flat)](https://travis-ci.org/fxm90/GradientLoadingBar) [![Version](https://img.shields.io/cocoapods/v/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar) [![License](https://img.shields.io/cocoapods/l/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar) [![Platform](https://img.shields.io/cocoapods/p/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar)

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
To integrate GradientLoadingBar into your Xcode project using Carthage, specify it in your Cartfile:
```
github "fxm90/GradientLoadingBar" ~> 1.0
```
Run carthage update to build the framework and drag the built GradientLoadingBar.framework into your Xcode project.
### How to use
To get started you'll have to import `GradientLoadingBar` into your file. To show the bar, simply call the `show()` method and after you're done with your operations call `hide()`.
```swift
let gradientLoadingBar = GradientLoadingBar()
gradientLoadingBar.show()

// Do e.g. server calls etc.

gradientLoadingBar.hide()
```
### Configuration
You can overwrite the default configuration by calling the initializers with the optional parameters `height`, `durations`, `gradientColorList` and `onView`:
```swift
let gradientLoadingBar = GradientLoadingBar(
    height: 1.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.0)
    gradientColorList: [
        UIColor(hex: "#4cd964"),
        UIColor(hex: "#ff2d55")
    ]
    onView: self.view
)
```
For using custom colors you'll have to pass an array with `UIColor` values. For creating those colors you can use all initializers for `UIColor` mentioned here: [UIColor+Initializers.swift](https://gist.github.com/fxm90/1350d27abf92af3be59aaa9eb72c9310)

For an example using the loading bar on a custom superview (e.g. an `UIButton` or `UINavigationBar` ) see the example application. For further customization you can also subclass `GradientLoadingBar` and overwrite the method `setupConstraints()`. This also shown in the __example application__.

#### – Shown underneath navigation bar
![Example](http://felix.hamburg/files/github/gradient-loading-bar/navigation-bar.jpg)

#### – Shown on custom superview
![Example](http://felix.hamburg/files/github/gradient-loading-bar/uibutton.jpg)

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
        UIColor(hex: "#4cd964"),
        UIColor(hex: "#ff2d55")
    ]
)
```

### Usage with PromiseKit
Check out [my GitHub Gist](https://gist.github.com/fxm90/698554e8335f34e0c6ab95194a4678fb) on how to easily use GradientLoadingBar with [PromiseKit](http://promisekit.org/).

### Author
Felix Mau (contact(@)felix.hamburg)

### License

GradientLoadingBar is available under the MIT license. See the LICENSE file for more info.
