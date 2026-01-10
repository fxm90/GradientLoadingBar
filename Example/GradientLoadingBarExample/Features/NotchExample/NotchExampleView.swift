//
//  NotchExampleView.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import GradientLoadingBar
import SwiftUI

/// An example view demonstrating the usage of the `NotchGradientLoadingBar`
struct NotchExampleView: View {

  private let notchGradientLoadingBar = NotchGradientLoadingBar()

  var body: some View {
    NavigationStack {
      VStack(spacing: .space4) {
        HStack(spacing: .space2) {
          Button {
            notchGradientLoadingBar.fadeOut()
          } label: {
            Label("Hide", systemImage: SFSymbol.eyeSlash.rawValue)
              .padding(.space1)
          }
          .buttonStyle(.borderedProminent)

          Button {
            notchGradientLoadingBar.fadeIn()
          } label: {
            Label("Show", systemImage: SFSymbol.eye.rawValue)
              .padding(.space1)
          }
          .buttonStyle(.borderedProminent)
        }

        Text("**Note:** In case the device doesn't have a notch, the loading bar will be displayed with a regular layout.")
          .font(.footnote)
          .multilineTextAlignment(.center)
          .padding(.horizontal, .space2)
      }
      .padding(.space6)
      .navigationTitle("Notch Example")
    }
    .onDisappear {
      notchGradientLoadingBar.fadeOut()
    }
  }
}

// MARK: - Preview

#Preview {
  // Previews do not provide a key window, therefore button interactions do not display the loading bar.
  // To view the loading bar in action, run the example application in the simulator.
  NotchExampleView()
}
