//
//  UIColor+GradientLoadingBar.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import SwiftUI
import UIKit

public extension UIColor {

  /// Color related configuration values for `GradientLoadingBar`.
  enum GradientLoadingBar {
    /// The default color palette for the gradient colors.
    ///
    /// Source: <https://codepen.io/marcobiedermann/pen/LExXWW>
    public static let gradientColors = [
      #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1), #colorLiteral(red: 0.3529411765, green: 0.7843137255, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), #colorLiteral(red: 0.2039215686, green: 0.6666666667, blue: 0.862745098, alpha: 1), #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1), #colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1),
    ]
  }
}

public extension Color {

  /// Color related configuration values for `GradientLoadingBar`.
  ///
  /// - Note: Added in `UIColor` extension file, cause these values are derived from
  ///         to the UIKit configuration values to ensure consistency across both frameworks.
  enum GradientLoadingBar {
    /// The default color palette for the gradient colors.
    public static let gradientColors =
      UIColor.GradientLoadingBar.gradientColors.map(Color.init)
  }
}
