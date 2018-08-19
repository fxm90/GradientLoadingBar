//
//  GradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//

import Foundation
import Observable

/// The `GradientLoadingBarViewModel` class is responsible for the visibility state of the gradient view.
class GradientLoadingBarViewModel {
    // MARK: - Public properties

    /// Boolean flag determinating whether gradient view is currently visible.
    private(set) var isVisible = Observable(false)

    /// Boolean flag determinating whether gradient view is currently visible.
    private(set) var superview: Observable<UIView?> = Observable(nil)

    // MARK: - Private properties

    // MARK: - Dependencies

    private let sharedApplication: UIApplicationProtocol
    private let notificationCenter: NotificationCenter

    // MARK: - Constructor

    init(superview: UIView?, sharedApplication: UIApplicationProtocol = UIApplication.shared, notificationCenter: NotificationCenter = .default) {
        self.sharedApplication = sharedApplication
        self.notificationCenter = notificationCenter

        if let superview = superview {
            self.superview.value = superview
        } else {
            // If the initializer is called from `appDelegate`, the key window is not available yet.
            // Therefore we setup an observer to inform the listeners when it's ready.
            notificationCenter.addObserver(self,
                                           selector: #selector(didReceiveUiWindowDidBecomeKeyNotification(_:)),
                                           name: UIWindow.didBecomeKeyNotification,
                                           object: nil)
        }
    }

    // MARK: - Private methods

    @objc private func didReceiveUiWindowDidBecomeKeyNotification(_: Notification) {
        guard let keyWindow = sharedApplication.keyWindow else { return }

        // Prevent informing the listeners multiple times.
        notificationCenter.removeObserver(self)

        superview.value = keyWindow
    }

    // MARK: - Public methods

    /// Fades in the gradient loading bar.
    func show() {
        guard !isVisible.value else { return }

        isVisible.value = true
    }

    /// Fades out the gradient loading bar.
    func hide() {
        guard isVisible.value else { return }

        isVisible.value = false
    }

    /// Toggle visiblity of gradient loading bar.
    func toggle() {
        isVisible.value.toggle()
    }
}

// MARK: - Helper

/// This allows mocking `UIApplication` in tests.
protocol UIApplicationProtocol {
    var keyWindow: UIWindow? { get }
}

extension UIApplication: UIApplicationProtocol {}
