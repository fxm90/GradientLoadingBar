//
//  UIKitExampleView.swift
//  GradientLoadingBarExample
//
//  Created by Felix Mau on 10.01.26.
//  Copyright © 2026 Felix Mau. All rights reserved.
//

import GradientLoadingBar
import SwiftUI
import UIKit

private enum Config {
  /// The custom gradient colors we use.
  ///
  /// Source: <https://color.adobe.com/Pink-Flamingo-color-theme-10343714/>
  static let gradientColors = [
    #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
  ]
}

/// A SwiftUI view that demonstrates the usage of `GradientActivityIndicatorView` from UIKit.
struct UIKitExampleView: View {
  var body: some View {
    NavigationStack {
      UIKitExampleViewControllerRepresentable()
        .navigationTitle("UIKit Example")
    }
  }
}

// MARK: - Supporting Types

/// A UIViewControllerRepresentable that wraps the `UIKitExampleViewController`.
private struct UIKitExampleViewControllerRepresentable: UIViewControllerRepresentable {
  func makeUIViewController(context _: Context) -> UIViewController {
    UIKitExampleViewController()
  }

  func updateUIViewController(_: UIViewController, context _: Context) {}
}

/// A UIViewController that showcases the `GradientActivityIndicatorView`
/// with default and custom gradient colors.
private final class UIKitExampleViewController: UIViewController {

  // MARK: - Private Properties

  private let contentStackView = UIStackView()

  private let defaultGradientColorsLabel = UILabel()
  private let defaultGradientActivityIndicatorView = GradientActivityIndicatorView()

  private let customGradientColorsLabel = UILabel()
  private let customGradientActivityIndicatorView = GradientActivityIndicatorView()

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpSubviews()
    setUpConstraints()
  }

  // MARK: - Private Methods

  private func setUpSubviews() {
    contentStackView.axis = .vertical
    contentStackView.alignment = .fill
    contentStackView.spacing = .space2
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentStackView)

    defaultGradientColorsLabel.text = "Default Gradient Colors"
    defaultGradientColorsLabel.textAlignment = .center
    defaultGradientColorsLabel.font = .preferredFont(forTextStyle: .callout)
    contentStackView.addArrangedSubview(defaultGradientColorsLabel)

    contentStackView.addArrangedSubview(defaultGradientActivityIndicatorView)
    contentStackView.setCustomSpacing(.space6, after: defaultGradientActivityIndicatorView)

    customGradientColorsLabel.text = "Custom Gradient Colors"
    customGradientColorsLabel.textAlignment = .center
    customGradientColorsLabel.font = .preferredFont(forTextStyle: .callout)
    contentStackView.addArrangedSubview(customGradientColorsLabel)

    customGradientActivityIndicatorView.gradientColors = Config.gradientColors
    contentStackView.addArrangedSubview(customGradientActivityIndicatorView)
  }

  private func setUpConstraints() {
    NSLayoutConstraint.activate([
      contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .space6),
      contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.space6),
      contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      defaultGradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: 3),

      customGradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: 3),
    ])
  }
}

// MARK: - Preview

#Preview {
  UIKitExampleView()
}
