//
//  GradientActivityIndicatorViewTestCase.swift
//  ExampleSnapshotTests
//
//  Created by Felix Mau on 09.11.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import XCTest
import SnapshotTesting

@testable import GradientLoadingBar

final class GradientActivityIndicatorViewTestCase: XCTestCase {
    // MARK: - Config

    private enum Config {
        /// The frame we use for rendering the `GradientActivityIndicatorView`.
        /// This will also be the image size for our snapshot.
        static let frame = CGRect(origin: .zero, size: CGSize(width: 375, height: 4))

        /// The custom colors we use on this test-case.
        /// Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        static let gradientColors = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
        ]
    }

    // MARK: - Test cases

    func test_gradientActivityIndicatorView_shouldContainCorrectDefaultColors() {
        // Given
        let gradientActivityIndicatorView = GradientActivityIndicatorView(frame: Config.frame)

        // We're only interested in the initial state containing the correct gradient-colors.
        // Therefore we're gonna remove the progress animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        assertSnapshot(matching: gradientActivityIndicatorView, as: .image)
    }

    func test_gradientActivityIndicatorView_shouldContainCorrectCustomColors() {
        // Given
        let gradientActivityIndicatorView = GradientActivityIndicatorView(frame: Config.frame)
        gradientActivityIndicatorView.gradientColors = Config.gradientColors

        // We're only interested in the initial state containing the correct gradient-colors.
        // Therefore we're gonna remove the progress animation.
        gradientActivityIndicatorView.layer.removeAllAnimations()

        // Then
        assertSnapshot(matching: gradientActivityIndicatorView, as: .image)
    }
}
