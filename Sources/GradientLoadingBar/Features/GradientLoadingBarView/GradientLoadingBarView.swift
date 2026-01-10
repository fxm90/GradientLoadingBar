//
//  GradientLoadingBarView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 08.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI
import UIKit

/// A SwiftUI view that displays an animated horizontal gradient, commonly used as a loading indicator.
///
/// ## Overview
///
/// `GradientLoadingBarView` renders a customizable color gradient that continuously animates from left to right,
/// creating an infinite scrolling effect.
///
/// ## Usage
///
/// ```swift
/// struct ContentView: some View {
///
///   var body: some View {
///     GradientLoadingBarView()
///       .frame(maxWidth: .infinity, maxHeight: 3)
///       .cornerRadius(1.5)
///   }
/// }
/// ```
///
/// ## Configuration
///
/// You can customize the gradient colors and animation speed:
///
/// ```swift
/// GradientLoadingBarView(
///   gradientColors: [.indigo, .purple, .pink],
///   progressDuration: 2.0
/// )
/// ```
///
/// ## Accessibility
///
/// The view is automatically hidden from accessibility technologies,
/// as it serves as a visual indicator only.
///
/// - Note: The animation starts automatically when the view appears and continues indefinitely.
///         Control visibility either by conditionally including the view in your hierarchy or by
///         applying the `opacity(_:)` or `hidden(_:)` view modifier.
///
/// - SeeAlso: ``GradientActivityIndicatorView`` for the UIKit equivalent.
public struct GradientLoadingBarView: View {

  // MARK: - Private Properties

  @State
  private var viewModel: ViewModel

  // MARK: - Initializer

  /// Creates a new gradient loading bar view.
  ///
  /// - Parameters:
  ///   - gradientColors: The colors used for the gradient.
  ///   - progressDuration: The duration for one complete animation cycle, measured in seconds.
  public init(
    gradientColors: [Color] = Color.GradientLoadingBar.gradientColors,
    progressDuration: TimeInterval = .GradientLoadingBar.progressDuration,
  ) {
    viewModel = ViewModel(
      gradientColors: gradientColors,
      progressDuration: progressDuration,
    )
  }

  // MARK: - Render

  public var body: some View {
    Color.clear
      .onGeometryChange(for: CGSize.self) { proxy in
        proxy.size
      } action: {
        // Restart a possible animation whenever the size changes.
        viewModel.size = $0
      }
      // Using an `overlay` here makes sure that the parent view won't change it's frame.
      .overlay(
        LinearGradient(
          colors: viewModel.gradientColors,
          startPoint: .leading,
          endPoint: .trailing,
        )
        .frame(width: viewModel.gradientWidth)
        .offset(x: viewModel.gradientOffset, y: 0),
      )
      .clipped()
      .accessibilityHidden(true)
  }
}

// MARK: - Preview

#Preview {
  GradientLoadingBarView()
    .frame(maxWidth: .infinity, maxHeight: .GradientLoadingBar.height)
    .padding(24)
}
