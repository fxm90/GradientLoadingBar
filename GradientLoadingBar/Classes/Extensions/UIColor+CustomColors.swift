//
//  UIColor+CustomColors.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 09/22/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit

extension UIColor {
    // MARK: - Types

    /// Struct that contains all our custom colors.
    struct CustomColors {
        static let grey = #colorLiteral(red: 0.8980392157, green: 0.9137254902, blue: 0.9215686275, alpha: 1)
        static let green = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        static let violet = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
        static let red = #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)

        static let blue = (malibu: #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), azure: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), curious: #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1))
    }

    // MARK: - Config

    ///
    public struct GradientLoadingBarDefaults {
        /// The default color palette for the gradient colors.
        ///
        /// - SeeAlso: https://codepen.io/marcobiedermann/pen/LExXWW
        public static let gradientColorList = [
            UIColor.CustomColors.green,
            UIColor.CustomColors.blue.malibu,
            UIColor.CustomColors.blue.azure,
            UIColor.CustomColors.blue.curious,
            UIColor.CustomColors.violet,
            UIColor.CustomColors.red
        ]
    }
}
