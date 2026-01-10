//
//  GradientLoadingBarView+ViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 21.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Observation
import SwiftUI

extension GradientLoadingBarView {

  /// This view model contains all logic related to the `GradientLoadingBarView`
  /// and the corresponding progress animation.
  @Observable
  final class ViewModel: ObservableObject {

    // MARK: - Internal Properties

    /// The gradient colors used for the progress animation,
    /// including the reversed colors to simulate an infinite animation.
    let gradientColors: [Color]

    /// The horizontal offset of the `LinearGradient` used to simulate the progress animation.
    private(set) var gradientOffset: CGFloat = 0

    /// The current size of the `GradientLoadingBarView`.
    var size: CGSize = .zero {
      didSet {
        // This will stop any ongoing animation.
        // Source: https://stackoverflow.com/a/59150940
        withAnimation(.linear(duration: 0)) {
          gradientOffset = -size.width
        }

        let progressAnimation: Animation = .linear(duration: progressDuration).repeatForever(autoreverses: false)
        withAnimation(progressAnimation) {
          gradientOffset = size.width
        }
      }
    }

    /// The width of the `LinearGradient`.
    var gradientWidth: CGFloat {
      // To fit the `gradientColors + reversedGradientColors + gradientColors` in our view,
      // we have to apply three times the width of our parent view.
      size.width * 3
    }

    // MARK: - Private Properties

    private let progressDuration: TimeInterval

    // MARK: - Instance Lifecycle

    init(gradientColors: [Color], progressDuration: TimeInterval) {
      self.gradientColors = gradientColors.infiniteGradientColors()
      self.progressDuration = progressDuration
    }
  }
}

// MARK: - Helper

private extension [Color] {
  /// Returns a color sequence suitable for a seamless, looping gradient animation.
  ///
  /// The resulting array mirrors the colors back and forth so the gradient can animate
  /// continuously without visible seams or duplicated colors at the turning points.
  ///
  /// To avoid duplicate colors at the inner edges, the reversed sequence omits
  /// the first and last elements before being appended.
  ///
  /// Example:
  /// ```
  /// [.red, .yellow, .green]
  /// → [.red, .yellow, .green, .yellow, .red, .yellow, .green]
  ///
  /// [.red, .yellow, .green, .blue]
  /// → [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]
  /// ```
  ///
  /// - Returns: A color array that can be animated left-to-right and looped without a visible jump.
  func infiniteGradientColors() -> [Color] {
    guard count > 1 else { return self }

    let reversedColors = reversed()
      .dropFirst()
      .dropLast()

    return self + reversedColors + self
  }
}
