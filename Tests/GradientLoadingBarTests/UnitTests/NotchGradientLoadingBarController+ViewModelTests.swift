//
//  NotchGradientLoadingBarController+ViewModelTests.swift
//  GradientLoadingBarTests
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Testing
@testable import GradientLoadingBar

@MainActor
@Suite
struct `NotchGradientLoadingBarController+ViewModelTests` {
  // swiftlint:disable:previous type_name

  // MARK: - Types

  typealias ViewModel = NotchGradientLoadingBarController.ViewModel

  // MARK: - Tests

  @Test(
    arguments: [
      "iPhone12,1": NotchDevice.iPhone11,
      "iPhone12,3": .iPhone11Pro,
      "iPhone12,5": .iPhone11ProMax,
      "iPhone13,1": .iPhone12Mini,
      "iPhone13,2": .iPhone12,
      "iPhone13,3": .iPhone12Pro,
      "iPhone13,4": .iPhone12ProMax,
      "iPhone14,4": .iPhone13Mini,
      "iPhone14,5": .iPhone13,
      "iPhone14,2": .iPhone13Pro,
      "iPhone14,3": .iPhone13ProMax,
      "iPhone14,7": .iPhone14,
      "iPhone14,8": .iPhone14Plus,
    ],
  )
  func `WHEN initialized with a valid device identifier THEN view model should return correct notch device`(
    deviceIdentifier: String,
    notchDevice: NotchDevice,
  ) {
    // When
    let viewModel = ViewModel(deviceIdentifier: deviceIdentifier)

    // Then
    #expect(viewModel.notchDevice == notchDevice)
  }

  @Test
  func `WHEN initialized with an invalid device identifier THEN view model should return no notch device`() {
    // Given
    let deviceIdentifier = "Foo-Bar-🤡"

    // When
    let viewModel = ViewModel(deviceIdentifier: deviceIdentifier)

    // Then
    #expect(viewModel.notchDevice == nil)
  }
}
