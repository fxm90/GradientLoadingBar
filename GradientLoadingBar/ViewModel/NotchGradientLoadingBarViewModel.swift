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

    enum SafeAreaDevice {
        case unknown
        case iPhoneX
        case iPhoneXR
        case iPhone11
        case iPhone12
        case iPhone13
    }

    // MARK: - Public properties

    /// The current safe area device.
    let safeAreaDevice: SafeAreaDevice

    // MARK: - Initializer

    init(deviceIdentifier: String = UIDevice.identifier) {
        safeAreaDevice = SafeAreaDevice(deviceIdentifier: deviceIdentifier)
    }
}

// MARK: - Helpers

private extension NotchGradientLoadingBarViewModel.SafeAreaDevice {
    /// Creates a new instance from a given `deviceIdentifier` (value returned by `UIDevice.identifier`).
    ///
    /// Taken from <https://stackoverflow.com/a/26962452/3532505>
    init(deviceIdentifier: String) {
        switch deviceIdentifier {
        case "iPhone10,3", "iPhone10,6", "iPhone11,2", "iPhone11,4", "iPhone11,6":
            self = .iPhoneX

        case "iPhone11,8":
            self = .iPhoneXR

        case "iPhone12,1", "iPhone12,3", "iPhone12,5":
            self = .iPhone11

        case "iPhone13,1", "iPhone13,2", "iPhone13,3", "iPhone13,4":
            self = .iPhone12

        case "iPhone14,4", "iPhone14,5", "iPhone14,2", "iPhone14,3":
            self = .iPhone13

        default:
            self = .unknown
        }
    }
}

private extension UIDevice {
    /// Returns the device identifier.
    ///
    /// Based on: <https://stackoverflow.com/a/26962452/3532505>
    /// Adapted for Simulator usage on <https://stackoverflow.com/a/46380596/3532505>
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
