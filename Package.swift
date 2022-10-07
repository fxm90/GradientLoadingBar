// swift-tools-version:5.5

import PackageDescription

let package = Package(name: "GradientLoadingBar",
                      platforms: [.iOS(.v13)],
                      products: [
                          .library(name: "GradientLoadingBar",
                                   targets: ["GradientLoadingBar"]),
                      ],
                      targets: [
                          .target(name: "GradientLoadingBar",
                                  path: "GradientLoadingBar/Sources"),
                          .testTarget(name: "GradientLoadingBarTests",
                                      dependencies: ["GradientLoadingBar"],
                                      path: "GradientLoadingBar/Tests/"),
                      ])
