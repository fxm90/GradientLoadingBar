//
//  NavigationBarExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/29/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class NavigationBarExampleViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var navigationBar: UINavigationBar!

    // MARK: - Private properties

    private var gradientProgressIndicatorView = GradientActivityIndicatorView()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientProgressIndicatorView()
    }

    @IBAction func showButtonTouchUpInside(_: Any) {
        gradientProgressIndicatorView.fadeIn()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        gradientProgressIndicatorView.fadeOut()
    }

    // MARK: - Private methods

    private func setupGradientProgressIndicatorView() {
        gradientProgressIndicatorView.fadeOut(duration: 0)

        gradientProgressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(gradientProgressIndicatorView)

        NSLayoutConstraint.activate([
            gradientProgressIndicatorView.leftAnchor.constraint(equalTo: navigationBar.leftAnchor),
            gradientProgressIndicatorView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor),

            gradientProgressIndicatorView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            gradientProgressIndicatorView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
    }
}

// MARK: - UIBarPositioningDelegate

/// - Note: Delegate is setted-up via storyboard.
extension NavigationBarExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
