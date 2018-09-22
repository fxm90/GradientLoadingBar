//
//  UIColor+CustomColors.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 22.09.18.
//

import UIKit

extension UIColor {
    /// Struct that contains all our custom defined colors.
    struct CustomColors {
        static let grey = #colorLiteral(red: 0.8980392157, green: 0.9137254902, blue: 0.9215686275, alpha: 1)
        static let green = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        static let violet = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
        static let red = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)

        /// As we're using three blue tones, we group them together.
        /// Names by [Name that color](http://chir.ag/projects/name-that-color/)
        static let blue = (malibu: #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), azure: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), curious: #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1))
    }
}
