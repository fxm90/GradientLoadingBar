//
//  GradientLoadingBarView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct GradientLoadingBarView: View {
    // MARK: - Config

    public enum Config {
        /// The default color palette for the gradient colors.
        public static let gradientColors = UIColor.GradientLoadingBar.gradientColors.map(Color.init)

        /// The default duration for the progress animation, measured in seconds.
        public static let progressDuration = TimeInterval.GradientLoadingBar.progressDuration
    }

    // MARK: - Private properties

    private let gradientColors: [Color]
    private let progressAnimation: Animation

    @State
    private var offset: CGFloat = 0

    // MARK: - Initializer

    public init(gradientColors: [Color] = Config.gradientColors,
                progressDuration: TimeInterval = Config.progressDuration) {
        // E.g. for array of [.red, .yellow, .green]
        // we will create    [.red, .yellow, .green, .yellow, .red, .yellow, .green]
        //
        // E.g. for array of [.red, .yellow, .green, .blue]
        // we will create    [.red, .yellow, .green, .blue, .green, .yellow, .red, .yellow, .green, .blue]
        var reversedGradientColors = Array(gradientColors.reversed())
        reversedGradientColors.removeFirst()
        reversedGradientColors.removeLast()

        self.gradientColors = gradientColors + reversedGradientColors + gradientColors

        progressAnimation = .linear(duration: progressDuration).repeatForever(autoreverses: false)
    }

    // MARK: - Render

    public var body: some View {
        GeometryReader { proxy in
            LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                // To fit `gradientColors + reversedGradientColors + gradientColors` in our view,
                // we have to apply three times the width of our parent view.
                .frame(width: proxy.size.width * 3)
                .offset(x: offset, y: 0)
                .onAppear {
                    // We want to animate from left to right.
                    // Therefore we start with the negative offset, and afterwards animate to an offset of zero.
                    offset = proxy.size.width * -2

                    withAnimation(progressAnimation) {
                        offset = 0
                    }
                }
        }
    }
}
