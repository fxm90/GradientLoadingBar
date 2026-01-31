//
//  GradientLoadingBarView+ViewModelTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 22.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI
import Testing
@testable import GradientLoadingBar

@MainActor
@Suite
struct `GradientLoadingBarView+ViewModelTests` {
  // swiftlint:disable:previous type_name

  // MARK: - Types

  typealias ViewModel = GradientLoadingBarView.ViewModel

  // MARK: - Test property `gradientColors`

  @Test
  func `WHEN initialized with a single gradient color THEN gradientColors should equal the single color`() {
    // Given
    let gradientColors: [Color] = [.red]

    // When
    let viewModel = ViewModel(gradientColors: gradientColors, progressDuration: 1)

    // Then
    let expectedGradientColors: [Color] = [.red]
    #expect(viewModel.gradientColors == expectedGradientColors)
  }

  @Test
  func `WHEN initialized with gradient colors THEN gradientColors should equal the infinite gradient colors`() {
    // Given
    let gradientColors: [Color] = [.red, .yellow, .green]

    // When
    let viewModel = ViewModel(gradientColors: gradientColors, progressDuration: 1)

    // Then
    let expectedGradientColors: [Color] = [.red, .yellow, .green, .yellow, .red, .yellow, .green]
    #expect(viewModel.gradientColors == expectedGradientColors)
  }

  // MARK: - Test Property `gradientOffset`

  @Test
  func `WHEN initialized THEN gradientOffset should be zero`() {
    // When
    let viewModel = ViewModel(gradientColors: [], progressDuration: 1)

    // Then
    #expect(viewModel.gradientOffset == 0)
  }

  @Test
  func `WHEN setting size THEN gradientOffset should be updated with new width`() {
    // Given
    let viewModel = ViewModel(gradientColors: [], progressDuration: 1)
    let size = CGSize(
      width: .random(in: 1 ... 100_000),
      height: .random(in: 1 ... 100_000),
    )

    // When
    viewModel.size = size

    // Then
    #expect(viewModel.gradientOffset == size.width)
  }

  // MARK: - Test Property `gradientWidth`

  @Test
  func `WHEN initialized THEN gradientWidth should be zero`() {
    // When
    let viewModel = ViewModel(gradientColors: [], progressDuration: 1)

    // Then
    #expect(viewModel.gradientWidth == 0)
  }

  @Test
  func `WHEN setting size THEN gradientWidth should be updated with correct width`() {
    // Given
    let viewModel = ViewModel(gradientColors: [], progressDuration: 1)
    let size = CGSize(
      width: .random(in: 1 ... 100_000),
      height: .random(in: 1 ... 100_000),
    )

    // When
    viewModel.size = size

    // Then
    #expect(viewModel.gradientWidth == size.width * 3)
  }
}
