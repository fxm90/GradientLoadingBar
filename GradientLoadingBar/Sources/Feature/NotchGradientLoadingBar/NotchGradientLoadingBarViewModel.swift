//
//  NotchGradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 03.10.21.
//  Copyright © 2021 Felix Mau. All rights reserved.
//

import UIKit

final class NotchGradientLoadingBarViewModel {

    // MARK: - Types

    enum NotchDevice {
        case iPhoneX
        case iPhoneXS
        case iPhoneXSMax
        case iPhoneXR
        case iPhone11
        case iPhone11Pro
        case iPhone11ProMax
        case iPhone12Mini
        case iPhone12
        case iPhone12Pro
        case iPhone12ProMax
        case iPhone13Mini
        case iPhone13
        case iPhone13Pro
        case iPhone13ProMax
        case iPhone14
        case iPhone14Plus
    }

    // MARK: - Public properties

    /// The current device if it has a notch / otherwise `nil`.
    let notchDevice: NotchDevice?

    // MARK: - Instance Lifecycle

    init(deviceIdentifier: String = UIDevice.identifier) {
        notchDevice = NotchDevice(deviceIdentifier: deviceIdentifier)
    }
}

// MARK: - Helper

private extension NotchGradientLoadingBarViewModel.NotchDevice {

    /// Creates a new instance from a given `deviceIdentifier` (value returned by `UIDevice.identifier`).
    ///
    /// - Note: This is taken from <https://stackoverflow.com/a/26962452/3532505>
    init?(deviceIdentifier: String) {
        // swiftlint:disable:previous cyclomatic_complexity
        switch deviceIdentifier {
        case "iPhone10,3", "iPhone10,6":
            self = .iPhoneX

        case "iPhone11,2":
            self = .iPhoneXS

        case "iPhone11,4", "iPhone11,6":
            self = .iPhoneXSMax

        case "iPhone11,8":
            self = .iPhoneXR

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

    /// Returns the device identifier.
    ///
    /// Based on: <https://stackoverflow.com/a/26962452/3532505>
    /// Adapted for Simulator usage based on <https://stackoverflow.com/a/46380596/3532505>
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
