//
//  GradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12/26/17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import Foundation
import LightweightObservable

/// The `GradientLoadingBarViewModel` class is responsible for the visibility state of the gradient view.
class GradientLoadingBarViewModel {
    // MARK: - Types

    /// This struct contains all infomation regarding an animated visibility update of the loading bar.
    struct VisibilityAnimation: Equatable {
        /// Initialize the struct with values set to zero / hidden.
        static let immediatelyHidden = VisibilityAnimation(duration: 0.0,
                                                           isHidden: true)

        /// The duration for the visibility update.
        let duration: TimeInterval

        /// Boolean flag, whether the view should be hidden.
        let isHidden: Bool
    }

    // MARK: - Public properties

    /// Observable for animated visibility updates for the gradient-view.
    var visibilityAnimation: Observable<VisibilityAnimation> {
        return visibilityAnimationSubject.asObservable
    }

    /// Observable for the superview of the gradient-view.
    var superview: Observable<UIView?> {
        return superviewSubject.asObservable
    }

    ///
    var fadeInDuration = Double.GradientLoadingBarDefaults.fadeInDuration

    ///
    var fadeOutDuration = Double.GradientLoadingBarDefaults.fadeOutDuration

    // MARK: - Private properties

    private let visibilityAnimationSubject: Variable<VisibilityAnimation> = Variable(.immediatelyHidden)

    private let superviewSubject: Variable<UIView?> = Variable(nil)

    // MARK: - Dependencies

    private let sharedApplication: UIApplicationProtocol
    private let notificationCenter: NotificationCenter

    // MARK: - Constructor

    init(sharedApplication: UIApplicationProtocol = UIApplication.shared,
         notificationCenter: NotificationCenter = .default) {
        self.sharedApplication = sharedApplication
        self.notificationCenter = notificationCenter

        if let keyWindow = sharedApplication.keyWindow {
            // We have a valid key window.
            superviewSubject.value = keyWindow
        } else {
            // The key window is not available yet. This can happen, if the initializer is called from
            // `UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)`.
            // Therefore we setup an observer to inform the view model when a `UIWindow` object becomes the key window.
            notificationCenter.addObserver(self,
                                           selector: #selector(didReceiveUIWindowDidBecomeKeyNotification(_:)),
                                           name: UIWindow.didBecomeKeyNotification,
                                           object: nil)
        }
    }

    // MARK: - Private methods

    @objc private func didReceiveUIWindowDidBecomeKeyNotification(_: Notification) {
        guard let keyWindow = sharedApplication.keyWindow else { return }

        // Prevent informing the listener multiple times.
        notificationCenter.removeObserver(self)

        // Now that we have a valid key window, we can use it as superview.
        superviewSubject.value = keyWindow
    }

    // MARK: - Public methods

    /// Fades in the gradient loading bar.
    func show() {
        visibilityAnimationSubject.value = VisibilityAnimation(duration: fadeInDuration,
                                                               isHidden: false)
    }

    /// Fades out the gradient loading bar.
    func hide() {
        visibilityAnimationSubject.value = VisibilityAnimation(duration: fadeOutDuration,
                                                               isHidden: true)
    }
}

// MARK: - Helper

/// This allows mocking `UIApplication` in tests.
protocol UIApplicationProtocol: AnyObject {
    var keyWindow: UIWindow? { get }
}

extension UIApplication: UIApplicationProtocol {}
