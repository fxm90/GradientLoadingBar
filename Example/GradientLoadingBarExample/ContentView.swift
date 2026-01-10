//
//  ContentView.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      Tab("Basic Example", systemImage: SFSymbol.iPhoneGen3.rawValue) {
        BasicExampleView()
      }
      Tab("Notch Example", systemImage: SFSymbol.iPhoneGen2.rawValue) {
        NotchExampleView()
      }
      Tab("UIKit Example", systemImage: SFSymbol.squareStack.rawValue) {
        UIKitExampleView()
      }
      Tab("SwiftUI Example", systemImage: SFSymbol.swift.rawValue) {
        SwiftUIExampleView()
      }
    }
    .overlay(alignment: .top) {
      Text("– Gradient Loading Bar Example –")
        .font(.caption)
        .offset(x: 0, y: .space3)
        .accessibilityHidden(true)
    }
  }
}

// MARK: - Preview

#Preview {
  ContentView()
}
