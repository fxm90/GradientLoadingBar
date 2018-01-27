//
//  GradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//

import Foundation

/// Classes implementing the `GradientLoadingBarViewModelDelegate` protocol get notified about visibility changes.
protocol GradientLoadingBarViewModelDelegate: class {

    /// Informs the delegate that the `keyWindow` is available.
    ///
    /// - Parameters:
    ///   - viewModel: The view model related to the gradient view.
    ///   - visible: The new key window that the gradient view should be added to.
    func viewModel(_ viewModel: GradientLoadingBarViewModel, didUpdateKeyWindow keyWindow: UIView)

    /// Informs the delegate about the new visible state of the gradient view.
    ///
    /// - Parameters:
    ///   - viewModel: The view model related to the gradient view.
    ///   - visible: The new visibility state of the gradient view.
    func viewModel(_ viewModel: GradientLoadingBarViewModel, didUpdateVisibility visible: Bool)
}

/// The `GradientLoadingBarViewModel` class is responsible for the visibility state of the gradient view.
class GradientLoadingBarViewModel {

    // MARK: - Public properties

    weak var delegate: GradientLoadingBarViewModelDelegate?

    /// Boolean flag, true if gradient view is currently visible, otherwise false.
    private(set) var isVisible = false {
        didSet {
            // Prevent calling delegate with same visibility state.
            if isVisible != oldValue {
                delegate?.viewModel(self, didUpdateVisibility: isVisible)
            }
        }
    }

    // MARK: - Private properties

    /// Observer waiting for `keyWindow` to be ready
    var keyWindowIsAvailableObserver: NSObjectProtocol?

    // Dependencies
    let sharedApplication: UIApplicationProtocol
    let notificationCenter: NotificationCenter

    init(sharedApplication: UIApplicationProtocol = UIApplication.shared,
         notificationCenter: NotificationCenter = NotificationCenter.default
    ) {
        self.sharedApplication = sharedApplication
        self.notificationCenter = notificationCenter
    }

    deinit {
        if let keyWindowIsAvailableObserver = keyWindowIsAvailableObserver {
            notificationCenter.removeObserver(keyWindowIsAvailableObserver)
        }
    }

    // MARK: - Handle `keyWindow` availability

    func setupObserverForKeyWindow() {
        guard let keyWindow = sharedApplication.keyWindow else {
            // If the controller initializer is called in `appDelegate` key window will not be available,
            // so we setup an observer to inform the delegate when it's ready.
            keyWindowIsAvailableObserver = notificationCenter.observeOnce(forName: .UIWindowDidBecomeKey) { _ in
                self.setupObserverForKeyWindow()
            }

            return
        }

        delegate?.viewModel(self, didUpdateKeyWindow: keyWindow)
    }

    // MARK: - Visibility methods

    /// Fade in the gradient loading bar.
    func show() {
        isVisible = true
    }

    /// Fade out the gradient loading bar.
    func hide() {
        isVisible = false
    }

    /// Toggle visiblity of gradient loading bar.
    func toggle() {
        isVisible = !isVisible
    }
}

// MARK: - Helper: Allow mocking `UIApplication` in tests

protocol UIApplicationProtocol {
    var keyWindow: UIWindow? { get }
}

extension UIApplication: UIApplicationProtocol {}
