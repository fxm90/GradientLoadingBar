//
//  BasicExampleView.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import GradientLoadingBar
import SwiftUI

/// A basic example view demonstrating the usage of the `GradientLoadingBar`.
struct BasicExampleView: View {

  private let relativeToSafeAreaLoadingBar = GradientLoadingBar()
  private let ignoringSafeAreaLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)

  var body: some View {
    NavigationStack {
      VStack(spacing: .space6) {
        VStack(spacing: .space2) {
          Text("Relative to Safe Area")
            .font(.headline)

          HStack(spacing: .space2) {
            Button {
              relativeToSafeAreaLoadingBar.fadeOut()
            } label: {
              Label("Hide", systemImage: SFSymbol.eyeSlash.rawValue)
                .padding(.space1)
            }
            .buttonStyle(.borderedProminent)

            Button {
              relativeToSafeAreaLoadingBar.fadeIn()
            } label: {
              Label("Show", systemImage: SFSymbol.eye.rawValue)
                .padding(.space1)
            }
            .buttonStyle(.borderedProminent)
          }
        }

        VStack(spacing: .space2) {
          Text("Ignores Safe Area")
            .font(.headline)

          HStack(spacing: .space2) {
            Button {
              ignoringSafeAreaLoadingBar.fadeOut()
            } label: {
              Label("Hide", systemImage: SFSymbol.eyeSlash.rawValue)
                .padding(.space1)
            }
            .buttonStyle(.borderedProminent)

            Button {
              ignoringSafeAreaLoadingBar.fadeIn()
            } label: {
              Label("Show", systemImage: SFSymbol.eye.rawValue)
                .padding(.space1)
            }
            .buttonStyle(.borderedProminent)
          }
        }
      }
      .padding(.space6)
      .navigationTitle("Basic Example")
    }
    .onDisappear {
      relativeToSafeAreaLoadingBar.fadeOut()
      ignoringSafeAreaLoadingBar.fadeOut()
    }
  }
}

// MARK: - Preview

#Preview {
  // Previews do not provide a key window, therefore button interactions do not display the loading bar.
  // To view the loading bar in action, run the example application in the simulator.
  BasicExampleView()
}
