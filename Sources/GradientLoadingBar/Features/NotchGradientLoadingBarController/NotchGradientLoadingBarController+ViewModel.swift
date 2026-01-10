//
//  NotchGradientLoadingBarController+ViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 03.10.21.
//  Copyright © 2021 Felix Mau. All rights reserved.
//

import UIKit

/// A protocol that abstracts the view model for dependency injection.
/// This enables snapshot testing the controller with all notch devices.
@MainActor
protocol NotchGradientLoadingBarViewModel: AnyObject {
  /// The notch device type if the current device has a notch, otherwise `nil`.
  var notchDevice: NotchDevice? { get }
}

extension NotchGradientLoadingBarController {

  /// This view model determines if the current device has a notch,
  /// and provides related information.
  @MainActor
  final class ViewModel: NotchGradientLoadingBarViewModel {

    // MARK: - Internal Properties

    /// The current device if it has a notch / otherwise `nil`.
    let notchDevice: NotchDevice?

    // MARK: - Instance Lifecycle

    init(deviceIdentifier: String = UIDevice.identifier) {
      notchDevice = NotchDevice(deviceIdentifier: deviceIdentifier)
    }
  }
}

// MARK: - Helper

private extension NotchDevice {
  /// Creates a notch device from the given hardware model identifier.
  ///
  /// - Parameter deviceIdentifier: The device's hardware model identifier (e.g. "iPhone14,5" for iPhone 13).
  ///
  /// - Returns: The corresponding `NotchDevice`, or `nil` if the identifier doesn't match a known notch device.
  ///
  /// - SeeAlso: <https://stackoverflow.com/a/26962452/3532505>
  init?(deviceIdentifier: String) {
    // swiftlint:disable:previous cyclomatic_complexity
    switch deviceIdentifier {
    case "iPhone12,1":
      self = .iPhone11
    case "iPhone12,3":
      self = .iPhone11Pro
    case "iPhone12,5":
      self = .iPhone11ProMax
    case "iPhone13,1":
      self = .iPhone12Mini
    case "iPhone13,2":
      self = .iPhone12
    case "iPhone13,3":
      self = .iPhone12Pro
    case "iPhone13,4":
      self = .iPhone12ProMax
    case "iPhone14,4":
      self = .iPhone13Mini
    case "iPhone14,5":
      self = .iPhone13
    case "iPhone14,2":
      self = .iPhone13Pro
    case "iPhone14,3":
      self = .iPhone13ProMax
    case "iPhone14,7":
      self = .iPhone14
    case "iPhone14,8":
      self = .iPhone14Plus
    default:
      return nil
    }
  }
}

private extension UIDevice {
  /// The hardware model identifier for the current device (e.g. "iPhone14,5" for iPhone 13).
  ///
  /// On the Simulator, this property returns the identifier of the simulated device.
  ///
  /// - SeeAlso:
  ///   - <https://stackoverflow.com/a/26962452/3532505>
  ///   - <https://stackoverflow.com/a/46380596/3532505>
  static var identifier: String {
    #if targetEnvironment(simulator)
      return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? ""
    #else
      var systemInfo = utsname()
      uname(&systemInfo)

      let machineMirror = Mirror(reflecting: systemInfo.machine)
      return machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else {
          return identifier
        }

        return identifier + String(UnicodeScalar(UInt8(value)))
      }
    #endif
  }
}
