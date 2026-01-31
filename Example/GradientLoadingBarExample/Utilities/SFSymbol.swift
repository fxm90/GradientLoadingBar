//
//  SFSymbol.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import SwiftUI
import UIKit

/// SF Symbols used by the example application.
///
/// Using an enum avoids hard-coded string literals and improves discoverability, autocompletion and compile-time safety.
/// The raw value of each case corresponds to the SF Symbol’s system name.
enum SFSymbol: String {
  case eye
  case eyeSlash = "eye.slash"
  case iPhoneGen2 = "iphone.gen2"
  case iPhoneGen3 = "iphone.gen3"
  case squareStack = "square.stack"
  case swift
}

// MARK: - Helper

extension Image {
  /// Creates a SwiftUI `Image` from an `SFSymbol`.
  ///
  /// ### Usage
  ///
  /// ```swift
  /// Image(sfSymbol: .house)
  /// ```
  ///
  /// - Parameter sfSymbol: The SF Symbol to display.
  init(sfSymbol: SFSymbol) {
    self.init(systemName: sfSymbol.rawValue)
  }
}

extension UIImage {
  /// Creates a `UIImage` from an `SFSymbol`.
  ///
  /// ### Usage
  ///
  /// ```swift
  /// let image = UIImage(sfSymbol: .plus)
  /// ```
  ///
  /// - Parameter sfSymbol: The SF Symbol to display.
  ///
  /// - Returns: A system image, or `nil` if the symbol name is invalid or
  ///            unavailable on the current OS version.
  convenience init?(sfSymbol: SFSymbol) {
    self.init(systemName: sfSymbol.rawValue)
  }
}
