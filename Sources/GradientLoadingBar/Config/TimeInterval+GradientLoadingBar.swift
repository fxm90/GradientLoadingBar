//
//  TimeInterval+GradientLoadingBar.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.08.19.
//  Copyright © 2019 Felix Mau. All rights reserved.
//

import Foundation

public extension TimeInterval {

  /// Time related configuration values for `GradientLoadingBar`.
  enum GradientLoadingBar {
    /// The default duration for fading-in the loading bar, measured in seconds.
    public static let fadeInDuration = 0.33

    /// The default duration for fading-out the loading bar, measured in seconds.
    public static let fadeOutDuration = 0.66

    /// The default duration for the progress animation, measured in seconds.
    public static let progressDuration = 3.33
  }
}
