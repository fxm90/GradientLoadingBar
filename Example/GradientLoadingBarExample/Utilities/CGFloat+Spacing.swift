//
//  CGFloat+Spacing.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import CoreGraphics

/// Standard spacing values based on a 4-point grid.
///
/// These constants provide a shared spacing scale to ensure visual consistency across layouts.
/// Values are expressed in points and increase in 4-point increments.
///
/// Naming follows the pattern `spaceN`, where `N` represents the number of 4-point units (e.g. `space3` = 12 points).
///
/// ### Usage
///
/// ```swift
/// VStack(spacing: .space4) {
///   Text("Title")
///   Text("Subtitle")
/// }
/// ```
extension CGFloat {
  static let space0: CGFloat = 0
  static let space1: CGFloat = 4
  static let space2: CGFloat = 8
  static let space3: CGFloat = 12
  static let space4: CGFloat = 16
  static let space5: CGFloat = 20
  static let space6: CGFloat = 24
  static let space8: CGFloat = 32
  static let space10: CGFloat = 40
}
