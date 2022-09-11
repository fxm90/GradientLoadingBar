// swift-tools-version:5.1

import PackageDescription

let package = Package(name: "GradientLoadingBar",
                      platforms: [.iOS(.v13)],
                      products: [
                          .library(name: "GradientLoadingBar",
                                   targets: ["GradientLoadingBar"]),
                      ],
                      targets: [
                          .target(name: "GradientLoadingBar",
                                  path: "GradientLoadingBar/"),
                          .testTarget(name: "GradientLoadingBarTests",
                                      dependencies: ["GradientLoadingBar"],
                                      path: "Example/ExampleTests/"),
                      ])
