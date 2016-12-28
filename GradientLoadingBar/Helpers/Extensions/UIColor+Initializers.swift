//
//  UIColor+AbsoluteRGB.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 20.11.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // Create color from RGB
    convenience init(absoluteRed: Int, green: Int, blue: Int) {
        self.init(
            absoluteRed: absoluteRed,
            green: green,
            blue: blue,
            alpha: 1.0
        )
    }
    
    // Create color from RGBA
    convenience init(absoluteRed: Int, green: Int, blue: Int, alpha: CGFloat) {
        let normalizedRed = CGFloat(absoluteRed) / 255
        let normalizedGreen = CGFloat(green) / 255
        let normalizedBlue = CGFloat(blue) / 255
        
        self.init(
            red: normalizedRed,
            green: normalizedGreen,
            blue: normalizedBlue,
            alpha: alpha
        )
    }
    
    // Color from HEX-Value
    // Based on: http://stackoverflow.com/a/24263296
    convenience init(hexValue:Int) {
        self.init(
            absoluteRed: (hexValue >> 16) & 0xff,
            green: (hexValue >> 8) & 0xff,
            blue: hexValue & 0xff
        )
    }
    
    // Color from HEX-String
    // Based on: http://stackoverflow.com/a/27203691
    convenience init(hexString:String) {
        var normalizedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (normalizedHexString.hasPrefix("#")) {
            normalizedHexString.remove(at: normalizedHexString.startIndex)
        }
        
        // Convert to hexadecimal integer
        var hexValue:UInt32 = 0
        Scanner(string: normalizedHexString).scanHexInt32(&hexValue)
        
        self.init(
            hexValue:Int(hexValue)
        )
    }
}
