//
//  GradientLoadingBarController+ViewModelTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Combine
import Testing
import UIKit
@testable import GradientLoadingBar

@MainActor
@Suite
struct `GradientLoadingBarController+ViewModelTests` {
  // swiftlint:disable:previous type_name

  // MARK: - Types

  typealias ViewModel = GradientLoadingBarController.ViewModel

  // MARK: - Private Properties

  private let sharedApplicationMock = SharedApplicationMock()
  private let notificationCenter = NotificationCenter()

  // MARK: - Test Property `superview`

  @Test
  func `WHEN initialized THEN superview should be nil`() {
    // When
    let viewModel = ViewModel(
      sharedApplication: sharedApplicationMock,
      notificationCenter: notificationCenter,
    )

    var receivedSuperviews = [UIView?]()
    let cancellable = viewModel.superview.sink {
      receivedSuperviews.append($0)
    }

    // Then
    withExtendedLifetime(cancellable) {
      #expect(receivedSuperviews == [nil])
    }
  }

  @Test
  func `WHEN initialized and having a firstKeyWindow THEN superview should equal firstKeyWindow`() {
    // Given
    let keyWindow = UIWindow()
    sharedApplicationMock.firstKeyWindow = keyWindow

    // When
    let viewModel = ViewModel(
      sharedApplication: sharedApplicationMock,
      notificationCenter: notificationCenter,
    )

    // Then
    var receivedSuperviews = [UIView?]()
    let cancellable = viewModel.superview.sink {
      receivedSuperviews.append($0)
    }

    // Then
    withExtendedLifetime(cancellable) {
      #expect(receivedSuperviews == [keyWindow])
    }
  }

  @Test
  func `WHEN initialized THEN superview should be firstKeyWindow after UIWindow.didBecomeKeyNotification posted`() {
    // Given
    let viewModel = ViewModel(
      sharedApplication: sharedApplicationMock,
      notificationCenter: notificationCenter,
    )

    var receivedSuperviews = [UIView?]()
    let cancellable = viewModel.superview.sink {
      receivedSuperviews.append($0)
    }

    // When
    let keyWindow = UIWindow()
    sharedApplicationMock.firstKeyWindow = keyWindow
    notificationCenter.post(name: UIWindow.didBecomeKeyNotification, object: nil)

    // Then
    withExtendedLifetime(cancellable) {
      let expectedSuperviews = [nil, keyWindow]
      #expect(receivedSuperviews == expectedSuperviews)
    }
  }

  @Test
  func `WHEN deinitialized THEN superview should be nil`() {
    // Given
    let keyWindow = UIWindow()
    sharedApplicationMock.firstKeyWindow = keyWindow

    var viewModel: ViewModel? = ViewModel(
      sharedApplication: sharedApplicationMock,
      notificationCenter: notificationCenter,
    )

    var receivedSuperviews = [UIView?]()
    let cancellable = viewModel?.superview.sink {
      receivedSuperviews.append($0)
    }

    // When
    viewModel = nil

    // Then
    withExtendedLifetime(cancellable) {
      let expectedSuperviews = [keyWindow, nil]
      #expect(receivedSuperviews == expectedSuperviews)
    }
  }
}

// MARK: - Mocks

private final class SharedApplicationMock: UIApplicationProtocol {
  var firstKeyWindow: UIWindow?
}
