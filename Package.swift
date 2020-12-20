// swift-tools-version:5.0

import PackageDescription

let package = Package(name: "GradientLoadingBar",
                      platforms: [.iOS(.v9)],
                      products: [
                          .library(name: "GradientLoadingBar",
                                   targets: ["GradientLoadingBar"]),
                      ],
                      dependencies: [
                          .package(url: "https://github.com/fxm90/LightweightObservable",
                                   .upToNextMajor(from: "2.0.0")),
                      ],
                      targets: [
                          .target(name: "GradientLoadingBar",
                                  dependencies: ["LightweightObservable"],
                                  path: "GradientLoadingBar/Classes"),
                          .testTarget(name: "GradientLoadingBarTests",
                                      dependencies: ["GradientLoadingBar"],
                                      path: "Example/Tests/"),
                      ])
