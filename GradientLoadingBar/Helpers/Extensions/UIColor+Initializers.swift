//
//  UIColor+AbsoluteRGB.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 20.11.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

// Source: https://gist.github.com/fxm90/1350d27abf92af3be59aaa9eb72c9310
public extension UIColor {

    // Create color from RGB(A)
    convenience init(absoluteRed: Int, green: Int, blue: Int, alpha: Int = 255) {
        let normalizedRed = CGFloat(absoluteRed) / 255.0
        let normalizedGreen = CGFloat(green) / 255.0
        let normalizedBlue = CGFloat(blue) / 255.0
        let normalizedAlpha = CGFloat(alpha) / 255.0

        self.init(
            red: normalizedRed,
            green: normalizedGreen,
            blue: normalizedBlue,
            alpha: normalizedAlpha
        )
    }

    // Color from HEX-Value
    // Based on: http://stackoverflow.com/a/24263296
    convenience init(hex: Int) {
        self.init(
            absoluteRed: (hex >> 16) & 0xff,
            green: (hex >> 8) & 0xff,
            blue: hex & 0xff
        )
    }

    // Color from HEX-String
    // Based on: http://stackoverflow.com/a/27203691
    convenience init(hexString: String) {
        var normalizedHexString = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        if normalizedHexString.hasPrefix("#") {
            normalizedHexString.remove(at: normalizedHexString.startIndex)
        }

        // Convert to hexadecimal integer
        var hexValue: UInt32 = 0
        Scanner(string: normalizedHexString).scanHexInt32(&hexValue)

        self.init(
            hex: Int(hexValue)
        )
    }
}
