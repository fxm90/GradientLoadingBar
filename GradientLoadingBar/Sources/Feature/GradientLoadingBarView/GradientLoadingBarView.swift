//
//  GradientLoadingBarView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

// Workaround to fix `xcodebuild` errors when running `pod lib lint`, like e.g.:
//
// - `xcodebuild`: error: cannot find type 'Color' in scope
// - `xcodebuild`: error: cannot find type 'View' in scope
//
// > This failure occurs because builds with a deployment target earlier than iOS 11 will also build for the armv7 architecture,
// > and there is no armv7 swiftmodule for SwiftUI in the iOS SDK because the OS version in which it was first introduced (iOS 13)
// > does not support armv7 anymore.
//
// Source: https://stackoverflow.com/a/61954608
#if arch(arm64) || arch(x86_64)

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

        @StateObject
        private var viewModel: ViewModel

        // MARK: - Initializer

        public init(gradientColors: [Color] = Config.gradientColors,
                    progressDuration: TimeInterval = Config.progressDuration) {
            // Even though the docs mention that "You don’t call this initializer directly", this seems to be the correct way to set-up a
            // `StateObject` with parameters according to "Lessons from the SwiftUI Digital Lounge".
            // https://swiftui-lab.com/random-lessons/#data-10
            _viewModel = StateObject(
                wrappedValue: ViewModel(gradientColors: gradientColors, progressDuration: progressDuration)
            )
        }

        // MARK: - Render

        public var body: some View {
            Color.clear
                // We explicitly have to use a `PreferenceKey` here and store the size on a property in order to restart the animation whenever
                // the size changes. Using a `GeometryReader` together with the `onAppear(_:)` view-modifier doesn't reflect any size changes.
                .modifier(SizeModifier())
                .onPreferenceChange(SizePreferenceKey.self) {
                    viewModel.size = $0
                }
                // Using an `overlay` here makes sure that the parent view won't change it's frame.
                .overlay(
                    LinearGradient(colors: viewModel.gradientColors, startPoint: .leading, endPoint: .trailing)
                        .frame(width: viewModel.gradientWidth)
                        .offset(x: viewModel.horizontalOffset, y: 0)
                )
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

#endif
