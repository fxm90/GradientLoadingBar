//
//  GradientLoadingBarViewModel.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//

import Foundation

/// Classes implementing the `GradientLoadingBarViewModelDelegate` protocol get notified about visibility changes.
protocol GradientLoadingBarViewModelDelegate: class {

    /// Informs the delegate about the new visible state of the gradient view.
    ///
    /// - Parameters:
    ///   - viewModel: The view model related to the gradient view.
    ///   - visible: The new visibility state of the gradient view.
    func viewModel(_ viewModel: GradientLoadingBarViewModel, didUpdateVisibility visible: Bool)
}

/// The `GradientLoadingBarViewModel` class is responsible for the visibility state of the gradient view.
class GradientLoadingBarViewModel {

    // MARK: - Properties

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

    // MARK: - Methods

    /// Fade in the gradient loading bar.
    public func show() {
        isVisible = true
    }

    /// Fade out the gradient loading bar.
    public func hide() {
        isVisible = false
    }

    /// Toggle visiblity of gradient loading bar.
    public func toggle() {
        isVisible = !isVisible
    }

}
