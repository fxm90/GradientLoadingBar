//
//  GradientActivityIndicatorView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12.10.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import UIKit

/// A view that displays an animated horizontal gradient, commonly used as a loading indicator.
///
/// ## Overview
///
/// `GradientActivityIndicatorView` renders a customizable color gradient that continuously
/// animates from left to right, creating an infinite scrolling effect.
///
/// ## Usage
///
/// ```swift
/// let gradientActivityIndicatorView = GradientActivityIndicatorView()
/// gradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
/// view.addSubview(loadingBar)
///
/// NSLayoutConstraint.activate([
///     gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
///     gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
///     gradientActivityIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
///     gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: 3)
/// ])
///
/// // Fade the view in.
/// gradientActivityIndicatorView.fadeIn()
///
/// // Fade the view out when finished.
/// gradientActivityIndicatorView.fadeOut()
/// ```
///
/// ## Configuration
///
/// You can customize the appearance and animation:
///
/// ```swift
/// loadingBar.gradientColors = [.systemIndigo, .systemPurple, .systemPink]
/// loadingBar.progressAnimationDuration = 2.0
/// ```
///
/// ## Animated Visibility Changes
///
/// For smooth fade-in and fade-out transitions, use the convenience animation methods:
///
/// ```swift
/// gradientActivityIndicatorView.fadeIn()
/// gradientActivityIndicatorView.fadeOut()
/// ```
///
/// ## Immediate Visibility Changes
///
/// For instant show/hide without animation, use the `isHidden` property:
///
/// ```swift
/// gradientActivityIndicatorView.isHidden = false
/// gradientActivityIndicatorView.isHidden = true
/// ```
///
/// ## Accessibility
///
/// The view is automatically hidden from accessibility technologies,
/// as it serves as a visual indicator only.
///
/// - Note: This view passes all touch events through to underlying views, making it safe
///         to overlay on interactive content without blocking user interaction.
///
/// - SeeAlso: ``GradientLoadingBarView`` for the SwiftUI equivalent.
public class GradientActivityIndicatorView: UIView {

  // MARK: - Config

  private enum Config {
    /// Animation-Key for the progress animation.
    static let progressAnimationKey = "progressAnimation"
  }

  // MARK: - Public Properties

  /// A Boolean value that determines whether the view is hidden.
  ///
  /// When set to `false`, the view becomes visible and starts the gradient animation.
  /// When set to `true`, the animation stops and the view is hidden.
  ///
  /// For animated visibility changes, use ``fadeIn(duration:completion:)`` or
  /// ``fadeOut(duration:completion:)`` instead of setting this property directly.
  override public var isHidden: Bool {
    didSet {
      viewModel.isHidden = isHidden
    }
  }

  /// The colors used for the gradient.
  public var gradientColors: [UIColor] {
    get { viewModel.gradientColors }
    set { viewModel.gradientColors = newValue }
  }

  /// The duration for one complete animation cycle, measured in seconds.
  public var progressAnimationDuration: TimeInterval {
    get { viewModel.progressAnimationDuration }
    set { viewModel.progressAnimationDuration = newValue }
  }

  // MARK: - Private Properties

  /// The layer holding the gradient.
  private let gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.anchorPoint = .zero
    layer.startPoint = .zero
    layer.endPoint = CGPoint(x: 1, y: 0)

    return layer
  }()

  /// The progress animation.
  private let progressAnimation: CABasicAnimation = {
    let animation = CABasicAnimation(keyPath: "position.x")
    animation.fromValue = 0
    animation.toValue = 0
    animation.duration = 0
    animation.isRemovedOnCompletion = false
    animation.repeatCount = Float.infinity

    return animation
  }()

  /// View model containing all logic related to this view.
  private let viewModel = ViewModel()

  // MARK: - Instance Lifecycle

  override public init(frame: CGRect) {
    super.init(frame: frame)

    setUpView()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    setUpView()
  }

  // MARK: - View Lifecycle

  override public func layoutSubviews() {
    super.layoutSubviews()

    viewModel.bounds = bounds
  }

  override public func updateProperties() {
    super.updateProperties()

    // Unfortunately the only way to update a running `CABasicAnimation`, is to restart it.
    // Mutating a running animation throws an exception!
    gradientLayer.removeAnimation(forKey: Config.progressAnimationKey)
    startProgressAnimationIfNeeded()
  }

  override public func point(inside _: CGPoint, with _: UIEvent?) -> Bool {
    // Passing all touches to the next view (if any), in the view stack.
    false
  }

  // MARK: - Private Methods

  private func setUpView() {
    layer.addSublayer(gradientLayer)
    layer.masksToBounds = true

    isAccessibilityElement = false
  }

  private func startProgressAnimationIfNeeded() {
    guard viewModel.isAnimating else { return }

    gradientLayer.frame = viewModel.gradientLayerFrame
    gradientLayer.colors = viewModel.gradientLayerColors
    progressAnimation.fromValue = viewModel.animationFromValue
    progressAnimation.toValue = viewModel.animationToValue
    progressAnimation.duration = viewModel.progressAnimationDuration
    gradientLayer.add(progressAnimation, forKey: Config.progressAnimationKey)
  }
}

// MARK: - Preview

#Preview {
  let viewController = UIViewController()

  let gradientActivityIndicatorView = GradientActivityIndicatorView()
  gradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
  viewController.view.addSubview(gradientActivityIndicatorView)

  NSLayoutConstraint.activate([
    gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 24),
    gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -24),
    gradientActivityIndicatorView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
    gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: 4),
  ])

  return viewController
}
