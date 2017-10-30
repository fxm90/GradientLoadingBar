GradientLoadingBar
====================

![Swift3.0](https://img.shields.io/badge/Swift-3.0-green.svg?style=flat) [![CI Status](http://img.shields.io/travis/fxm90/GradientLoadingBar.svg?style=flat)](https://travis-ci.org/fxm90/GradientLoadingBar) [![Version](https://img.shields.io/cocoapods/v/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar) [![License](https://img.shields.io/cocoapods/l/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar) [![Platform](https://img.shields.io/cocoapods/p/GradientLoadingBar.svg?style=flat)](http://cocoapods.org/pods/GradientLoadingBar)

### Example
An animated gradient loading bar.
Inspired by [iOS Style Gradient Progress Bar with Pure CSS/CSS3](http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/).

![Example](http://felix.hamburg/files/github/gradient-loading-bar/screen.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Integration
GradientLoadingBar can be added to your project using [CocoaPods](https://cocoapods.org/) by adding the following line to your Podfile:
```
pod 'GradientLoadingBar', '~> 1.0'
```
### How to use
To get started you need to import `GradientLoadingBar`. To show it, simply call the `show()` method and after you're done with your operations call `hide()`.
```swift
// Create instance
let gradientLoadingBar = GradientLoadingBar()

// Show loading bar
gradientLoadingBar.show()

// Do e.g. server calls etc.

// Hide loading bar
gradientLoadingBar.hide()
```
### Configuration
You can overwrite the default configuration by calling the initializers with the optional parameters `height`, `durations`, `gradientColors` and `onView`:
```swift
let gradientLoadingBar = GradientLoadingBar(
    height: 1.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.0)
    gradientColors: [
        UIColor(hexString:"#4cd964").cgColor,
        UIColor(hexString:"#ff2d55").cgColor
    ]
    onView: self.view
)
```
For custom colors you'll have to pass an array with `CGColor` values. For creating those colors you can use all initializers for `UIColor`  mentioned here: [UIColor+Initializers.swift](https://gist.github.com/fxm90/1350d27abf92af3be59aaa9eb72c9310)

For an example using the loading bar on a custom superview (e.g. an UIButton) see the example application. For further cusomization you can also subclass `GradientLoadingBar` and overwrite the method `setupConstraints()`. This also shown in the example application.

#### Custom shared instance
If you don't want to save the instance on a variable and use the singleton instead, you can use the static `shared` variable. Add the following code to your app delegate `didFinishLaunchingWithOptions` method:
```swift
GradientLoadingBar.shared = GradientLoadingBar(
    height: 3.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.00),
    gradientColors: [
        UIColor(hexString:"#4cd964").cgColor,
        UIColor(hexString:"#ff2d55").cgColor
    ]
)
```
After that you can use `GradientLoadingBar.shared` to get the instance.

### Usage with PromiseKit
Check out [my GitHub Gist](https://gist.github.com/fxm90/698554e8335f34e0c6ab95194a4678fb) on how to easily use GradientLoadingBar with [PromiseKit](http://promisekit.org/).

### Author
Felix Mau (contact(@)felix.hamburg)

### License

GradientLoadingBar is available under the MIT license. See the LICENSE file for more info.