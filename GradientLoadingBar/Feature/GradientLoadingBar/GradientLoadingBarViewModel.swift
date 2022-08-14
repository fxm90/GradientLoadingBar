//
//  GradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import LightweightObservable
import UIKit

/// This view model checks for the availability of the key-window,
/// and adds it as a superview to the gradient-view.
final class GradientLoadingBarViewModel {

    // MARK: - Public properties

    /// Observable for the superview of the gradient-view.
    var superview: Observable<UIView?> {
        superviewSubject
    }

    // MARK: - Private properties

    private let superviewSubject: Variable<UIView?> = Variable(nil)

    // MARK: - Dependencies

    private let sharedApplication: UIApplicationProtocol
    private let notificationCenter: NotificationCenter

    // MARK: - Instance Lifecycle

    init(sharedApplication: UIApplicationProtocol = UIApplication.shared, notificationCenter: NotificationCenter = .default) {
        self.sharedApplication = sharedApplication
        self.notificationCenter = notificationCenter

        if let keyWindow = sharedApplication.keyWindowInConnectedScenes {
            superviewSubject.value = keyWindow
        }

        // The key window might be not available yet. This can happen, if the initializer is called from
        // `UIApplicationDelegate.application(_:didFinishLaunchingWithOptions:)`.
        // Furthermore the key window can change. Therefore we setup an observer to inform the view model
        // when a `UIWindow` object becomes the key window.
        notificationCenter.addObserver(self,
                                       selector: #selector(didReceiveUIWindowDidBecomeKeyNotification(_:)),
                                       name: UIWindow.didBecomeKeyNotification,
                                       object: nil)
    }

    deinit {
        /// By providing a custom de-initializer we make sure to remove the gradient-view from its superview.
        superviewSubject.value = nil
    }

    // MARK: - Private methods

    @objc private func didReceiveUIWindowDidBecomeKeyNotification(_: Notification) {
        guard let keyWindow = sharedApplication.keyWindowInConnectedScenes else { return }

        superviewSubject.value = keyWindow
    }
}

// MARK: - Helper

/// This allows mocking `UIApplication` in tests.
protocol UIApplicationProtocol: AnyObject {
    var keyWindowInConnectedScenes: UIWindow? { get }
}

extension UIApplication: UIApplicationProtocol {
    /// Returns the current key window across multiple iOS versions.
    var keyWindowInConnectedScenes: UIWindow? {
        guard #available(iOS 15.0, *) else {
            return windows.first { $0.isKeyWindow }
        }

        // Starting from iOS 15.0 we need to use `UIWindowScene.windows` on a relevant window scene instead.
        // Source: https://stackoverflow.com/a/58031897
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
