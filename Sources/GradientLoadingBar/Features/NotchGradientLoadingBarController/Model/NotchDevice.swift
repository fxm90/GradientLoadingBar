//
//  NotchDevice.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 18.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

/// iPhone models that feature a notch (TrueDepth camera housing) at the top of the display.
///
/// - Note: iPhone 14 Pro and later models use the Dynamic Island instead of a notch
///         and are therefore not included in this list.
enum NotchDevice: String, CaseIterable {
  // These devices are excluded because they don't support the minimum required iOS version (iOS 26).
  // https://support.apple.com/guide/iphone/iphone-models-compatible-with-ios-26-iphe3fa5df43/ios
  // case iPhoneX
  // case iPhoneXS
  // case iPhoneXSMax
  // case iPhoneXR

  case iPhone11
  case iPhone11Pro
  case iPhone11ProMax
  case iPhone12Mini
  case iPhone12
  case iPhone12Pro
  case iPhone12ProMax
  case iPhone13Mini
  case iPhone13
  case iPhone13Pro
  case iPhone13ProMax
  case iPhone14
  case iPhone14Plus
}
