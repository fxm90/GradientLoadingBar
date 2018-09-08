//
//  Durations.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 27.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation

/// Animation durations for fade-in / fade-out and progress animations.
/// All values are in seconds.
public struct Durations {
    // MARK: - Config

    /// The default durations for the loading bar.
    public static let `default` = Durations(fadeIn: 0.33, fadeOut: 0.66, progress: 3.33)

    // MARK: - Public Properties

    /// Duration (in sec.) for fade in animation.
    let fadeIn: Double

    /// Duration (in sec.) for fade out animation.
    let fadeOut: Double

    /// Duration (in sec.) for progress animation.
    let progress: Double

    // MARK: - Initializers

    // Self-written initializer is required to allow public access
    // Source: http://stackoverflow.com/a/26224873/3532505

    /// Handles durations for `GradientLoadingBar`.
    ///
    /// Parameters:
    ///  - fadeIn:   Duration (in sec.) for fade in animation.
    ///  - fadeOut:  Duration (in sec.) for fade out animation.
    ///  - progress: Duration (in sec.) for progress animation.
    ///
    /// Returns: Instance of durations.
    public init(fadeIn: Double = 0.0, fadeOut: Double = 0.0, progress: Double = 0.0) {
        self.fadeIn = fadeIn
        self.fadeOut = fadeOut
        self.progress = progress
    }
}
