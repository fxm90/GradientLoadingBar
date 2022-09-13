//
//  GradientLoadingBarView+ViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 21.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Combine
import SwiftUI

// See documentation of `GradientLoadingBarView` for further details
// on this compile condition.
#if arch(arm64) || arch(x86_64)

    @available(iOS 15.0, *)
    extension GradientLoadingBarView {
        /// This view model contains all logic related to the `GradientLoadingBarView`
        /// and the corresponding progress animation.
        final class ViewModel: ObservableObject {

            // MARK: - Public properties

            /// The gradient colors used for the progress animation (including the reversed colors).
            let gradientColors: [Color]

            /// The horizontal offset of the `LinearGradient` used to simulate the progress animation.
            @Published
            private(set) var horizontalOffset: CGFloat = 0

            /// The current size of the `GradientLoadingBarView`.
            @Published
            var size: CGSize = .zero {
                didSet {
                    // This will stop any ongoing animation.
                    // Source: https://stackoverflow.com/a/59150940
                    withAnimation(.linear(duration: 0)) {
                        horizontalOffset = -size.width
                    }

                    let progressAnimation: Animation = .linear(duration: progressDuration).repeatForever(autoreverses: false)
                    withAnimation(progressAnimation) {
                        horizontalOffset = size.width
                    }
                }
            }

            /// The width of the `LinearGradient`.
            var gradientWidth: CGFloat {
                // To fit `gradientColors + reversedGradientColors + gradientColors` in our view,
                // we have to apply three times the width of our parent view.
                size.width * 3
            }

            // MARK: - Private properties

            private var progressDuration: TimeInterval

            // MARK: - Instance Lifecycle

            init(gradientColors: [Color], progressDuration: TimeInterval) {
                // Simulate infinite animation - Therefore we'll reverse the colors and remove the first and last item
                // to prevent duplicate values at the "inner edges" destroying the infinite look.
                //
                // E.g. for array of [.red, .yellow, .green]
                // we will create    [.red, .yellow, .green, .yellow, .red, .yellow, .green]
                //
                // E.g. for array of [.red, .yellow, .green, .blue]
                // we will create    [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]
                let reversedGradientColors = gradientColors
                    .reversed()
                    .dropFirst()
                    .dropLast()

                self.gradientColors = gradientColors + reversedGradientColors + gradientColors
                self.progressDuration = progressDuration
            }
        }
    }

#endif
