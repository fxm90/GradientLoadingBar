//
//  GradientActivityIndicatorView+ViewModelTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Testing
import UIKit
@testable import GradientLoadingBar

@MainActor
@Suite
struct `GradientActivityIndicatorView+ViewModelTests` {
  // swiftlint:disable:previous type_name

  // MARK: - Types

  typealias ViewModel = GradientActivityIndicatorView.ViewModel

  // MARK: - Test Property `isHidden`

  @Test
  func `WHEN initialized THEN isHidden should be false`() {
    // When
    let viewModel = ViewModel()

    // Then
    #expect(!viewModel.isHidden)
  }

  // MARK: - Test Property `isAnimating`

  @Test
  func `WHEN isHidden is false THEN isAnimating should be true`() {
    // Given
    let viewModel = ViewModel()

    // When
    viewModel.isHidden = false

    // Then
    #expect(viewModel.isAnimating)
  }

  @Test
  func `WHEN isHidden is true THEN isAnimating should be false`() {
    // Given
    let viewModel = ViewModel()

    // When
    viewModel.isHidden = true

    // Then
    #expect(!viewModel.isAnimating)
  }

  // MARK: - Test Property `bounds`

  @Test
  func `WHEN initialized THEN bounds should be zero`() {
    // When
    let viewModel = ViewModel()

    // Then
    #expect(viewModel.bounds == .zero)
  }

  // MARK: - Test Property `gradientLayerFrame`

  @Test
  func `WHEN setting bounds THEN gradientLayerFrame should be updated with correct width`() {
    // Given
    let viewModel = ViewModel()
    let size = CGSize(
      width: .random(in: 1 ... 100_000),
      height: .random(in: 1 ... 100_000),
    )

    // When
    viewModel.bounds = CGRect(origin: .zero, size: size)

    // Then
    let expectedFrame = CGRect(
      origin: .zero,
      size: CGSize(width: size.width * 3, height: size.height),
    )

    #expect(viewModel.gradientLayerFrame == expectedFrame)
  }

  // MARK: - Test Property `animationFromValue`

  @Test
  func `WHEN setting bounds THEN animationFromValue should be updated with correct value`() {
    // Given
    let viewModel = ViewModel()
    let size = CGSize(
      width: .random(in: 1 ... 100_000),
      height: .random(in: 1 ... 100_000),
    )

    // When
    viewModel.bounds = CGRect(origin: .zero, size: size)

    // Then
    #expect(viewModel.animationFromValue == size.width * -2)
  }

  // MARK: - Test Property `animationToValue`

  @Test
  func `WHEN initialized THEN animationToValue should be zero`() {
    // When
    let viewModel = ViewModel()

    // Then
    #expect(viewModel.animationToValue == 0)
  }

  // MARK: - Test Property `gradientColors`

  @Test
  func `WHEN initialized THEN gradientColors should equal default colors`() {
    // When
    let viewModel = ViewModel()

    // Then
    #expect(viewModel.gradientColors == UIColor.GradientLoadingBar.gradientColors)
  }

  // MARK: - Test Property `gradientLayerColors`

  @Test
  func `WHEN setting gradientColors with a single color THEN gradientLayerColors should equal the single color`() {
    // Given
    let viewModel = ViewModel()
    let gradientColors: [UIColor] = [.red]

    // When
    viewModel.gradientColors = gradientColors

    // Then
    let expectedGradientLayerColors = [UIColor.red].map(\.cgColor)
    #expect(viewModel.gradientLayerColors == expectedGradientLayerColors)
  }

  @Test
  func `WHEN setting gradientColors THEN gradientLayerColors should equal the infinite gradient colors`() {
    // Given
    let viewModel = ViewModel()
    let gradientColors: [UIColor] = [.red, .yellow, .green]

    // When
    viewModel.gradientColors = gradientColors

    // Then
    let expectedGradientLayerColors = [UIColor.red, .yellow, .green, .yellow, .red, .yellow, .green].map(\.cgColor)
    #expect(viewModel.gradientLayerColors == expectedGradientLayerColors)
  }

  // MARK: - Test Property `progressAnimationDuration`

  @Test
  func `WHEN initialized THEN progressAnimationDuration should contain default duration`() {
    // When
    let viewModel = ViewModel()

    // Then
    #expect(viewModel.progressAnimationDuration == TimeInterval.GradientLoadingBar.progressDuration)
  }
}
