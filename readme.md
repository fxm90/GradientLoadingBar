GradientLoadingBar
====================

![Swift3.0](https://img.shields.io/badge/Swift-3.0-blue.svg?style=flat)

An animated gradient loading bar.
Inspired by [iOS Style Gradient Progress Bar with Pure CSS/CSS3](http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/).

![Example](http://felix.hamburg/files/github/gradient-loading-bar/screen.gif)

### Integration
GradientLoadingBar can be added to your project using [CocoaPods](https://cocoapods.org/) by adding the following line to your Podfile:
```
pod 'GradientLoadingBar', '~> 1.0'
```
### How to use
First you need to import __"GradientLoadingBar"__. After that you can use __"GradientLoadingBar.sharedInstance()"__ to retrieve an instance to the loading bar. To show it, simply call the __"show()"__ method and after you're done call __"hide()"__.
```
// Show loading bar
GradientLoadingBar.sharedInstance().show()

// Do e.g. server calls etc.

// Hide loading bar
GradientLoadingBar.sharedInstance().hide()
```

### Configuration
You can overwrite the default configuration by calling the initializers with the optional params __"height"__ and __"durations"__:
```
let loadingBar = GradientLoadingBar(
    height: 1.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.00)
)
```

If you don't want to save the instance on a variable and use the singleton instead, you can use the __"saveInstance()"__ method. Add the following code to your app delegate __"didFinishLaunchingWithOptions"__ method:
```
GradientLoadingBar(
    height: 1.0,
    durations: Durations(fadeIn: 1.0, fadeOut: 2.0, progress: 3.00)
).saveInstance()
```

After that you can use __"GradientLoadingBar.sharedInstance()"__ as mentioned above.

### Usage with PromiseKit
Check out [my GitHub Gist](https://gist.github.com/fxm90/698554e8335f34e0c6ab95194a4678fb) on how to easily use GradientLoadingBar with [PromiseKit](promisekit.org).

### Version
1.0.0

### Author
Felix Mau (contact(@)felix.hamburg)
