//
//  GradientLoadingBarViewSnapshotTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 09.11.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import GradientLoadingBar

/// - Note: For more readable reference file names, we don't use raw identifiers for test names here.
@MainActor
@Suite
struct GradientLoadingBarViewSnapshotTests {

  // MARK: - Config

  private enum Config {
    /// The frame we use for rendering the `GradientLoadingBarView`.
    /// This will also be the image size of our reference image.
    static let frame = CGRect(origin: .zero, size: CGSize(width: 375, height: 4))

    /// The custom colors we use on this test-case.
    ///
    /// Source: <https://color.adobe.com/Pink-Flamingo-color-theme-10343714/>
    static let gradientColors = [
      #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
    ].map(Color.init)
  }

  // MARK: - Tests

  @Test
  func gradientLoadingBarView_withDefaultGradientColors() {
    // Given
    let gradientLoadingBarView = GradientLoadingBarView()
      .frame(width: Config.frame.width, height: Config.frame.height)

    // Then
    assertSnapshot(of: gradientLoadingBarView, as: .image)
  }

  @Test
  func gradientLoadingBarView_withCustomGradientColors() {
    // Given
    let gradientLoadingBarView = GradientLoadingBarView(gradientColors: Config.gradientColors)
      .frame(width: Config.frame.width, height: Config.frame.height)

    // Then
    assertSnapshot(of: gradientLoadingBarView, as: .image)
  }
}
