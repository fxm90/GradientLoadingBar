//
//  EntryPointView.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

struct EntryPointView: View {
    // MARK: - Private properties

    @State
    private var isNavigationBarExampleVisible = false

    // MARK: - Render

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("UIKit Examples")) {
                    NavigationLink(destination: BasicExampleView()) {
                        TitleSubtitleView(title: "🏡 Basic Example",
                                          subtitle: "Basic usage and setup.")
                    }

                    NavigationLink(destination: SafeAreaExampleView()) {
                        TitleSubtitleView(title: "📲 Safe Area Example",
                                          subtitle: "Loading bar ignoring the safe area.")
                    }

                    NavigationLink(destination: AdvancedExampleView()) {
                        TitleSubtitleView(title: "🚀 Advanced Example",
                                          subtitle: "How to apply e.g. custom colors.")
                    }

                    Button {
                        isNavigationBarExampleVisible = true
                    } label: {
                        TitleSubtitleView(title: "🧭 Navigation Bar Example",
                                          subtitle: "Attach the loading bar to a navigation bar.")
                            // Make entire row tappable and not just the text.
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Section(header: Text("SwiftUI Examples")) {
                    NavigationLink(destination: SwiftUIExampleView()) {
                        TitleSubtitleView(title: "🎨 GradientLoadingBarView Example",
                                          subtitle: "How to use the SwiftUI view.")
                    }
                }
            }
            // We present the `NavigationBarExampleView` as a sheet using it's own navigation controller.
            // The `NavigationView` passed from SwiftUI isn't accessible from a `UIViewController` in a way, that we can add subviews to it.
            .sheet(isPresented: $isNavigationBarExampleVisible) {
                NavigationBarExampleView()
            }
            // Unfortunately setting the title here results in constraint warnings.
            // I couldn't find a possible fix yet, even `.navigationViewStyle(.stack)` doesn't seem to work.
            // https://stackoverflow.com/q/65316497
            .navigationTitle("GradientLoadingBar")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Subviews

private struct TitleSubtitleView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

struct EntryPointView_Previews: PreviewProvider {
    static var previews: some View {
        EntryPointView()
    }
}
