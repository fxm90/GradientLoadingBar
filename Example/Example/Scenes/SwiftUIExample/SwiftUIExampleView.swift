//
//  SwiftUIExampleView.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI
import GradientLoadingBar

struct SwiftUIExampleView: View {

    // MARK: - Render

    var body: some View {
        List {
            Section(header: Text("Default example")) {
                DefaultExampleView()
            }

            Section(header: Text("Custom colors")) {
                CustomColorsExampleView()
            }

            Section(header: Text("Custom animation duration")) {
                CustomProgressDurationExampleView()
            }
        }
        .navigationTitle("🎨 SwiftUI Example")
    }
}

// MARK: - Subviews

private struct DefaultExampleView: View {

    @State
    private var isVisible = true

    var body: some View {
        VStack(spacing: 16) {
            Text("Example using the default configuration.")
                .frame(maxWidth: .infinity, alignment: .leading)

            GradientLoadingBarView()
                .frame(maxWidth: .infinity, maxHeight: 3)
                .cornerRadius(1.5)
                .opacity(isVisible ? 1 : 0)

            HStack(spacing: 16) {
                Button("Show") {
                    withAnimation(.easeInOut) {
                        isVisible = true
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())

                Button("Hide") {
                    withAnimation(.easeInOut) {
                        isVisible = false
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }
}

private struct CustomColorsExampleView: View {

    private enum Config {
        /// The custom gradient colors we use.
        /// Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        static let gradientColors = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
        ].map(Color.init)
    }

    @State
    private var isVisible = true

    var body: some View {
        VStack(spacing: 16) {
            Text("Example showing how to provide custom gradient colors.")
                .frame(maxWidth: .infinity, alignment: .leading)

            GradientLoadingBarView(gradientColors: Config.gradientColors)
                .frame(maxWidth: .infinity, maxHeight: 3)
                .cornerRadius(1.5)
                .opacity(isVisible ? 1 : 0)

            HStack(spacing: 16) {
                Button("Show") {
                    withAnimation(.easeInOut) {
                        isVisible = true
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())

                Button("Hide") {
                    withAnimation(.easeInOut) {
                        isVisible = false
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }
}

private struct CustomProgressDurationExampleView: View {

    private enum Config {
        /// The custom progress duration to use.
        static let progressDuration: TimeInterval = 10
    }

    @State
    private var isVisible = true

    var body: some View {
        VStack(spacing: 16) {
            Text("Example showing how to provide a custom progress animation duration.")
                .frame(maxWidth: .infinity, alignment: .leading)

            GradientLoadingBarView(progressDuration: Config.progressDuration)
                .frame(maxWidth: .infinity, maxHeight: 3)
                .cornerRadius(1.5)
                .opacity(isVisible ? 1 : 0)

            HStack(spacing: 16) {
                Button("Show") {
                    withAnimation(.easeInOut) {
                        isVisible = true
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())

                Button("Hide") {
                    withAnimation(.easeInOut) {
                        isVisible = false
                    }
                }
                .buttonStyle(RoundedRectangleButtonStyle())
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }
}

// MARK: - Helper

private struct RoundedRectangleButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(12)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue.cornerRadius(8))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

// MARK: - Preview

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
