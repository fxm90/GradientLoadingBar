//
//  Durations.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 27.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation

public struct Durations {
    let fadeIn: Double
    let fadeOut: Double
    let progress: Double

    // Self-written initializer is required to allow public access
    // Source: http://stackoverflow.com/a/26224873/3532505
    public init(fadeIn: Double = 0.0, fadeOut: Double = 0.0, progress: Double = 0.0) {
        self.fadeIn = fadeIn
        self.fadeOut = fadeOut
        self.progress = progress
    }
}
