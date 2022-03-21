//
//  GradientLoadingBarView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

// For some reason the animation looks broken on iOS versions <= 15.0.
@available(iOS 15.0, *)
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
    private let progressDuration: TimeInterval

    @State
    private var size: CGSize = .zero {
        didSet {
            // This will stop the ongoing animation.
            // Source: https://stackoverflow.com/a/59150940
            withAnimation(.linear(duration: 0)) {
                offset = size.width * -1
            }

            withAnimation(.linear(duration: progressDuration).repeatForever(autoreverses: false)) {
                offset = size.width * 1
            }
        }
    }

    @State
    private var offset: CGFloat = 0

    // MARK: - Initializer

    public init(gradientColors: [Color] = Config.gradientColors,
                progressDuration: TimeInterval = Config.progressDuration) {
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

    // MARK: - Render

    public var body: some View {
        Color.clear
            // We explicitly have to use a `PreferenceKey` here and store the size on a property in order to restart the animation whenever
            // the size changes. Using a `GeometryReader` together with the `onAppear(_:)` view-modifier doesn't reflect any size changes.
            .modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self) {
                size = $0
            }
            // Using an `overlay` here makes sure that the parent view won't change it's frame.
            .overlay(//
                LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing)
                    // To fit `gradientColors + reversedGradientColors + gradientColors` in our view,
                    // we have to apply three times the width of our parent view.
                    .frame(width: size.width * 3)
                    .offset(x: offset, y: 0))
    }
}

// MARK: - Helper

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

@available(iOS 15.0, *)
private struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear.preference(key: SizePreferenceKey.self,
                                       value: geometry.size)
            }
        )
    }
}
