//
//  GradientLoadingBarView+ViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 21.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import Combine
import SwiftUI

@available(iOS 15.0, *)
extension GradientLoadingBarView {
    ///
    ///
    final class ViewModel: ObservableObject {
        // MARK: - Public properties

        let gradientColors: [Color]

        @Published
        private(set) var offset: CGFloat = 0

        @Published
        var size: CGSize = .zero {
            didSet {
                // This will stop any ongoing animation.
                // Source: https://stackoverflow.com/a/59150940
                withAnimation(.linear(duration: 0)) {
                    offset = -size.width
                }

                withAnimation(.linear(duration: progressDuration).repeatForever(autoreverses: false)) {
                    offset = size.width
                }
            }
        }

        var gradientWidth: CGFloat {
            // To fit `gradientColors + reversedGradientColors + gradientColors` in our view,
            // we have to apply three times the width of our parent view.
            size.width * 3
        }

        // MARK: - Private properties

        private var progressDuration: TimeInterval

        // MARK: - Public methods

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
