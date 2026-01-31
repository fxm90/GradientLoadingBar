//
//  GradientLoadingBarController+ViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Combine
import UIKit

/// A protocol that abstracts the view model for dependency injection.
/// This enables snapshot testing the controller without requiring a host application.
@MainActor
protocol GradientLoadingBarViewModel: AnyObject {
  /// A publisher that emits the current superview (key window) for the gradient loading bar.
  var superview: AnyPublisher<UIView?, Never> { get }
}

extension GradientLoadingBarController {

  /// This view model checks for the availability of the key-window,
  /// and adds it as a superview to the gradient-view.
  ///
  /// - Note: While Observation works great with SwiftUI and UIKit views,
  ///         there’s a lot of work to be done for it to be usable from other places.
  ///         We therefore fallback to using Combine here.
  @MainActor
  final class ViewModel: GradientLoadingBarViewModel {

    // MARK: - Internal Properties

    /// Observable for the superview of the gradient-view.
    var superview: AnyPublisher<UIView?, Never> {
      superviewSubject.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private let superviewSubject = CurrentValueSubject<UIView?, Never>(nil)
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Instance Lifecycle

    init(
      sharedApplication: UIApplicationProtocol = UIApplication.shared,
      notificationCenter: NotificationCenter = .default,
    ) {
      if let keyWindow = sharedApplication.firstKeyWindow {
        superviewSubject.value = keyWindow
      }

      // The key window might be not available yet. This can happen, if the initializer is called from
      // `UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)`.
      // Also the key window can change. We therefore setup an observer be notified when a new window becomes the key window.
      notificationCenter
        .publisher(for: UIWindow.didBecomeKeyNotification)
        .compactMap { _ in sharedApplication.firstKeyWindow }
        .sink { [weak self] keyWindow in
          self?.superviewSubject.value = keyWindow
        }
        .store(in: &subscriptions)
    }

    @MainActor
    deinit {
      // Unsubscribe here, because the notification callback could theoretically fire during deinitialization.
      subscriptions.removeAll()

      // Removes the gradient-view from its superview.
      superviewSubject.value = nil
    }
  }
}

// MARK: - Helper

/// A protocol abstracting `UIApplication` for dependency injection.
/// This enables unit testing the view model.
@MainActor
protocol UIApplicationProtocol: AnyObject {
  /// The first window in the connected scenes that is currently the key window.
  var firstKeyWindow: UIWindow? { get }
}

extension UIApplication: UIApplicationProtocol {
  /// The first window in the connected scenes that is currently the key window.
  ///
  /// - SeeAlso: <https://stackoverflow.com/a/58031897>
  var firstKeyWindow: UIWindow? {
    connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first { $0.isKeyWindow }
  }
}
