GradientLoadingBar
====================

![Swift3.0](https://img.shields.io/badge/Swift-3.0-green.svg?style=flat) ![Version](https://img.shields.io/cocoapods/v/GradientLoadingBar.svg)

An animated gradient loading bar.
Inspired by [iOS Style Gradient Progress Bar with Pure CSS/CSS3](http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/).

![Example](http://felix.hamburg/files/github/gradient-loading-bar/screen.gif)

### Integration
GradientLoadingBar can be added to your project using [CocoaPods](https://cocoapods.org/) by adding the following line to your Podfile:
```
pod 'GradientLoadingBar', '~> 1.0'
```
### How to use
To get started you need to import `GradientLoadingBar`. After that you can use `GradientLoadingBar.sharedInstance()` to retrieve an instance to the loading bar. To show it, simply call the `show()` method and after you're done call `hide()`.
```swift
// Show loading bar
GradientLoadingBar.sharedInstance().show()

// Do e.g. server calls etc.

// Hide loading bar
GradientLoadingBar.sharedInstance().hide()
```

### Configuration
You can overwrite the default configuration by calling the initializers with the optional params `height`, `durations` and `gradientColors`:
```swift
let loadingBar = GradientLoadingBar(
    height: 1.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.0)
    gradientColors: [
        UIColor(hexString:"#4cd964").cgColor,
        UIColor(hexString:"#ff2d55").cgColor
    ]
)
```
For custom colors you have to pass an array with `CGColor` values. For creating those colors you can use all initializers for `UIColor`  mentioned here: [UIColor+Initializers.swift](https://gist.github.com/fxm90/1350d27abf92af3be59aaa9eb72c9310)

#### Custom shared instance
If you don't want to save the instance on a variable and use the singleton instead, you can use the `saveInstance()` method. Add the following code to your app delegate `didFinishLaunchingWithOptions` method:
```swift
GradientLoadingBar(
    height: 3.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.00),
    gradientColors: [
        UIColor(hexString:"#4cd964").cgColor,
        UIColor(hexString:"#ff2d55").cgColor
    ]
).saveInstance()
```

After that you can use `GradientLoadingBar.sharedInstance()` as mentioned above.

### Usage with PromiseKit
Check out [my GitHub Gist](https://gist.github.com/fxm90/698554e8335f34e0c6ab95194a4678fb) on how to easily use GradientLoadingBar with [PromiseKit](http://promisekit.org/).

### Version
1.1.1

### Author
Felix Mau (contact(@)felix.hamburg)
