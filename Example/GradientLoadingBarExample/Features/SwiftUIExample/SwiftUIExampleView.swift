//
//  SwiftUIExampleView.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import GradientLoadingBar
import SwiftUI

private enum Config {
  /// The custom gradient colors we use.
  ///
  /// Source: <https://color.adobe.com/Pink-Flamingo-color-theme-10343714/>
  static let gradientColors = [
    #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
  ].map(Color.init)
}

/// A SwiftUI view demonstrating the usage of the `GradientLoadingBarView`,
/// showcasing both default and custom gradient colors.
struct SwiftUIExampleView: View {
  var body: some View {
    NavigationStack {
      VStack(spacing: .space6) {
        VStack(spacing: .space2) {
          Text("Default Gradient Colors")
            .font(.callout)

          GradientLoadingBarView()
            .frame(height: 3)
            .clipShape(RoundedRectangle(cornerRadius: 1.5))
        }

        VStack(spacing: .space2) {
          Text("Custom Gradient Colors")
            .font(.callout)

          GradientLoadingBarView(
            gradientColors: Config.gradientColors,
          )
          .frame(height: 3)
          .clipShape(RoundedRectangle(cornerRadius: 1.5))
        }
      }
      .padding(.space6)
      .navigationTitle("SwiftUI Example")
    }
  }
}

// MARK: - Preview

#Preview {
  SwiftUIExampleView()
}
