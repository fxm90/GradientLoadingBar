//
//  Snapshotting+WindowedImage.swift
//  GradientLoadingBar_SnapshotTests
//
//  Created by Felix Mau on 06/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SnapshotTesting

// MARK: - Config

private enum Config {
    /// Allow for a 1% pixel difference.
    static let precision: Float = 0.99
}

// MARK: - Public properties

extension Snapshotting where Value: UIViewController, Format == UIImage {
    /// Based on:
    /// <https://github.com/pointfreeco/swift-snapshot-testing/issues/279> and <https://www.pointfree.co/episodes/ep86-swiftui-snapshot-testing#t657>
    static var windowedImage: Snapshotting {
        Snapshotting<UIImage, UIImage>.image(precision: Config.precision).asyncPullback { viewController in
            Async<UIImage> { callback in
                UIView.setAnimationsEnabled(false)

                guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    fatalError("⚠️ – Failed to get key window from application!")
                }
                keyWindow.rootViewController = viewController

                DispatchQueue.main.async {
                    let image = UIGraphicsImageRenderer(bounds: keyWindow.bounds).image { _ in
                        keyWindow.drawHierarchy(in: keyWindow.bounds, afterScreenUpdates: true)
                    }
                    callback(image)

                    UIView.setAnimationsEnabled(true)
                }
            }
        }
    }
}
