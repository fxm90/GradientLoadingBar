//
//  GradientLoadingBarController.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12.11.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Combine
import UIKit

/// Type-alias for the controller to match the package name.
public typealias GradientLoadingBar = GradientLoadingBarController

/// A controller that manages an animated gradient loading bar positioned at the top of the screen.
///
/// ## Overview
///
/// `GradientLoadingBarController` provides a simple way to display a gradient loading indicator
/// similar to those seen in Safari or Instagram. The controller automatically adds its view to the
/// application's key window and positions it at the top of the screen.
///
/// ## Basic Usage
///
/// For most use cases, prefer the shared instance provided by `GradientLoadingBar.shared`.
///
/// ```swift
/// // Fade the loading bar in.
/// GradientLoadingBar.shared.fadeIn()
///
/// // Fade the loading bar out when finished.
/// GradientLoadingBar.shared.fadeOut()
/// ```
///
/// This shared instance can be overridden to customize the loading bar globally.
///
/// ## Configuration
///
/// You can create custom instances with different configurations:
///
/// ```swift
/// let gradientLoadingBar = GradientLoadingBar(
///   height: 5,
///   isRelativeToSafeArea: false
/// )
///
/// gradientLoadingBar.gradientColors = [.systemIndigo, .systemPurple, .systemPink]
/// gradientLoadingBar.progressAnimationDuration = 4.5
/// ```
///
/// ## Animated Visibility Changes
///
/// For smooth fade-in and fade-out transitions, use the convenience animation methods:
///
/// ```swift
/// gradientLoadingBar.fadeIn()
/// gradientLoadingBar.fadeOut()
/// ```
///
/// ## Immediate Visibility Changes
///
/// For instant show/hide without animation, use the `isHidden` property:
///
/// ```swift
/// gradientLoadingBar.isHidden = false
/// gradientLoadingBar.isHidden = true
/// ```
///
/// ## Thread Safety
///
/// This class is marked with `@MainActor` and must be accessed from the main thread.
///
/// - SeeAlso: ``GradientActivityIndicatorView`` for the underlying view that renders the gradient.
@MainActor
public class GradientLoadingBarController {

  // MARK: - Public Properties

  /// The shared singleton instance of the gradient loading bar.
  ///
  /// You can customize the shared instance's appearance at any time:
  /// ```swift
  /// GradientLoadingBar.shared.gradientColors = [.systemIndigo, .systemPurple, .systemPink]
  /// ```
  public static var shared = GradientLoadingBar()

  /// The colors used for the gradient.
  public var gradientColors: [UIColor] {
    get { gradientActivityIndicatorView.gradientColors }
    set { gradientActivityIndicatorView.gradientColors = newValue }
  }

  /// The duration for one complete animation cycle, measured in seconds.
  public var progressAnimationDuration: TimeInterval {
    get { gradientActivityIndicatorView.progressAnimationDuration }
    set { gradientActivityIndicatorView.progressAnimationDuration = newValue }
  }

  /// A Boolean value that determines whether the loading bar is hidden.
  ///
  /// Set this property to `false` to show the loading bar immediately (without animation),
  /// or to `true` to hide it immediately.
  ///
  /// For animated visibility changes, use ``fadeIn(duration:completion:)`` or
  /// ``fadeOut(duration:completion:)`` instead.
  public var isHidden: Bool {
    get { gradientActivityIndicatorView.isHidden }
    set { gradientActivityIndicatorView.isHidden = newValue }
  }

  // MARK: - Internal Properties

  /// The view containing the gradient layer.
  ///
  ///  - Note: This property needs to have an internal access level to allow
  ///          accessing this view in ``NotchGradientLoadingBarController``.
  let gradientActivityIndicatorView = GradientActivityIndicatorView()

  /// The height of the gradient bar.
  ///
  ///  - Note: This property needs to have an internal access level to allow
  ///          accessing this value in ``NotchGradientLoadingBarController``.
  let height: CGFloat

  // MARK: - Private Properties

  /// Boolean flag whether the top layout constraint should respect the `safeAreaLayoutGuide`.
  private let isRelativeToSafeArea: Bool

  /// The view model for our controller.
  private let viewModel: GradientLoadingBarViewModel

  /// The dispose bag for the observables.
  private var subscriptions = Set<AnyCancellable>()

  // MARK: - Instance Lifecycle

  /// Internal initializer for dependency injection.
  /// This allows snapshot testing the controller with a mocked view model.
  init(
    height: CGFloat,
    isRelativeToSafeArea: Bool,
    gradientLoadingBarViewModel viewModel: GradientLoadingBarViewModel,
  ) {
    self.height = height
    self.isRelativeToSafeArea = isRelativeToSafeArea
    self.viewModel = viewModel

    bindViewModelToView()

    // We don't want the view to be visible initially.
    isHidden = true
  }

  /// Creates a new gradient loading bar controller.
  ///
  /// - Parameters:
  ///   - height: The height of the gradient bar in points.
  ///   - isRelativeToSafeArea: Boolean flag whether the top layout constraint should respect the `safeAreaLayoutGuide`.
  public convenience init(
    height: CGFloat = .GradientLoadingBar.height,
    isRelativeToSafeArea: Bool = true,
  ) {
    self.init(
      height: height,
      isRelativeToSafeArea: isRelativeToSafeArea,
      gradientLoadingBarViewModel: ViewModel(),
    )
  }

  @MainActor
  deinit {
    gradientActivityIndicatorView.removeFromSuperview()
  }

  // MARK: - Public Methods

  /// Animates the gradient loading bar from hidden to fully visible.
  ///
  /// - Parameters:
  ///   - duration: The animation duration, in seconds.
  ///   - completion: An optional closure invoked when the animation ends.
  ///                 The Boolean parameter indicates whether the animation
  ///                 completed successfully (`true`) or was interrupted (`false`).
  public func fadeIn(
    duration: TimeInterval = .GradientLoadingBar.fadeInDuration,
    completion: ((Bool) -> Void)? = nil,
  ) {
    gradientActivityIndicatorView.fadeIn(
      duration: duration,
      completion: completion,
    )
  }

  /// Animates the gradient loading bar from visible to fully transparent.
  ///
  /// - Parameters:
  ///   - duration: The animation duration, in seconds.
  ///   - completion: An optional closure invoked when the animation ends.
  ///                 The Boolean parameter indicates whether the animation
  ///                 completed successfully (`true`) or was interrupted (`false`).
  public func fadeOut(
    duration: TimeInterval = .GradientLoadingBar.fadeOutDuration,
    completion: ((Bool) -> Void)? = nil,
  ) {
    gradientActivityIndicatorView.fadeOut(
      duration: duration,
      completion: completion,
    )
  }

  // MARK: - Internal Methods

  /// Applies the layout constraints for the `GradientActivityIndicatorView`.
  ///
  ///  - Note: This method needs to have an internal access level to allow
  ///          overwriting it in ``NotchGradientLoadingBarController``.
  func setupConstraints(superview: UIView) {
    let superViewTopAnchor = if isRelativeToSafeArea {
      superview.safeAreaLayoutGuide.topAnchor
    } else {
      superview.topAnchor
    }

    NSLayoutConstraint.activate([
      gradientActivityIndicatorView.topAnchor.constraint(equalTo: superViewTopAnchor),
      gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: height),

      gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
    ])
  }

  // MARK: - Private Methods

  private func bindViewModelToView() {
    viewModel.superview.sink { [weak self] superview in
      self?.updateSuperview(superview)
    }.store(in: &subscriptions)
  }

  private func updateSuperview(_ superview: UIView?) {
    // If the views superview is not `nil`, the superview releases the view.
    gradientActivityIndicatorView.removeFromSuperview()

    if let superview {
      gradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
      superview.addSubview(gradientActivityIndicatorView)

      setupConstraints(superview: superview)
    }
  }
}
