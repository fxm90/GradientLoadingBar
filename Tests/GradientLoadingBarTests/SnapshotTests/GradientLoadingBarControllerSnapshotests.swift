//
//  GradientLoadingBarControllerSnapshotests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 14.06.20.
//  Copyright © 2020 Felix Mau. All rights reserved.
//

import Combine
import SnapshotTesting
import Testing
import UIKit
@testable import GradientLoadingBar

/// - Note: For more readable reference file names, we don't use raw identifiers for test names here.
@MainActor
@Suite
struct GradientLoadingBarControllerSnapshotTests {
  // swiftlint:disable:previous type_name

  // MARK: - Config

  private enum Config {
    /// The frame we use for rendering the `GradientLoadingBarController`.
    /// This will also be the image size of our reference image.
    ///
    /// - Note: We explicitly don't simulate a full device height here, to avoid unnecessary large images.
    static let frame = CGRect(origin: .zero, size: CGSize(width: 375, height: 100))

    /// The safe area insets we use on this test-case.
    ///
    /// Source: <https://useyourloaf.com/blog/iphone-17-screen-sizes/>
    static let safeAreaInset = UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0)
  }

  // MARK: - Tests

  @Test
  func gradientLoadingBarController_withIsRelativeToSafeAreaFalse() {
    // Given
    let mockSafeAreaView = MockSafeAreaView(frame: Config.frame)
    mockSafeAreaView.stubbedSafeAreaInsets = Config.safeAreaInset

    let mockGradientLoadingBarViewModel = MockGradientLoadingBarViewModel(
      superview: Just(mockSafeAreaView).eraseToAnyPublisher(),
    )

    // When
    let controller = GradientLoadingBarController(
      height: .GradientLoadingBar.height,
      isRelativeToSafeArea: false,
      gradientLoadingBarViewModel: mockGradientLoadingBarViewModel,
    )
    controller.isHidden = false

    // Then
    assertSnapshot(of: mockSafeAreaView, as: .image)
  }

  @Test
  func gradientLoadingBarController_withIsRelativeToSafeAreaTrue() {
    // Given
    let mockSafeAreaView = MockSafeAreaView(frame: Config.frame)
    mockSafeAreaView.stubbedSafeAreaInsets = Config.safeAreaInset

    let mockGradientLoadingBarViewModel = MockGradientLoadingBarViewModel(
      superview: Just(mockSafeAreaView).eraseToAnyPublisher(),
    )

    // When
    let controller = GradientLoadingBarController(
      height: .GradientLoadingBar.height,
      isRelativeToSafeArea: true,
      gradientLoadingBarViewModel: mockGradientLoadingBarViewModel,
    )
    controller.isHidden = false

    // Then
    assertSnapshot(of: mockSafeAreaView, as: .image)
  }
}

// MARK: - Supporting Types

private final class MockGradientLoadingBarViewModel: GradientLoadingBarViewModel {
  var superview: AnyPublisher<UIView?, Never>

  init(superview: AnyPublisher<UIView?, Never>) {
    self.superview = superview
  }
}

/// A `UIView` subclass that allows manual control of `safeAreaInsets`.
private final class MockSafeAreaView: UIView {
  var stubbedSafeAreaInsets: UIEdgeInsets = .zero

  override var safeAreaInsets: UIEdgeInsets {
    stubbedSafeAreaInsets
  }
}
