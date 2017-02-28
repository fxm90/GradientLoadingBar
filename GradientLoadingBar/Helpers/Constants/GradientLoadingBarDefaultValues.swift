//
//  GradientLoadingBarDefaults.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 28.02.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Foundation

public struct GradientLoadingBarDefaultValues {
    static let height = 2.5
    
    static let durations =
        Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)
    
    // iOS color palette
    // From: http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/
    public static let gradientColors : GradientColors = [
        UIColor(hexString:"#4cd964").cgColor,
        UIColor(hexString:"#5ac8fa").cgColor,
        UIColor(hexString:"#007aff").cgColor,
        UIColor(hexString:"#34aadc").cgColor,
        UIColor(hexString:"#5856d6").cgColor,
        UIColor(hexString:"#ff2d55").cgColor
    ]
}
