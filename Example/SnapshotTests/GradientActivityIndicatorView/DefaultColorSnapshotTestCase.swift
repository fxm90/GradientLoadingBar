//
//  DefaultColorSnapshotTestCase.swift
//  GradientLoadingBar_SnapshotTests
//
//  Created by Felix Mau on 09.11.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import GradientLoadingBar

class DefaultColorSnapshotTestCase: XCTestCase {
    // MARK: - Config

    /// The frame we use for rendering the `GradientLoadingBar`. This will also be the image size for our snapshot.
    private static let frame = CGRect(origin: .zero, size: CGSize(width: 375, height: 4))

    // MARK: - Test cases

    func testGradientProgressIndicatorViewShouldContainCorrectColorsInitially() {
        // When
        let gradientActivityIndicatorView = GradientActivityIndicatorView(frame: Self.frame)

        // We're only interested in the initial state containing the correct gradient-colors.
        // Therefore we're gonna remove the progress animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        assertSnapshot(matching: gradientActivityIndicatorView, as: .image)
    }
}
