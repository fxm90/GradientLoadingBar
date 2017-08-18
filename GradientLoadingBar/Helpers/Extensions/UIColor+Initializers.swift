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
    convenience init(absoluteRed: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let normalizedRed = CGFloat(absoluteRed) / 255.0
        let normalizedGreen = CGFloat(green) / 255.0
        let normalizedBlue = CGFloat(blue) / 255.0

        self.init(
            red: normalizedRed,
            green: normalizedGreen,
            blue: normalizedBlue,
            alpha: alpha
        )
    }

    // Color from HEX-Value
    // Based on: http://stackoverflow.com/a/24263296
    convenience init(hexValue: Int) {
        self.init(
            absoluteRed: (hexValue >> 16) & 0xff,
            green: (hexValue >> 8) & 0xff,
            blue: hexValue & 0xff
        )
    }

    // Color from HEX-String
    // Based on: http://stackoverflow.com/a/27203691
    convenience init(hexString: String) {
        var normalizedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if normalizedHexString.hasPrefix("#") {
            normalizedHexString.remove(at: normalizedHexString.startIndex)
        }

        // Convert to hexadecimal integer
        var hexValue: UInt32 = 0
        Scanner(string: normalizedHexString).scanHexInt32(&hexValue)

        self.init(
            hexValue:Int(hexValue)
        )
    }
}
