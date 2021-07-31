//
//  NavigationBarExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 29.08.18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class NavigationBarExampleViewController: UIViewController {
    // MARK: - Config

    private enum Config {
        /// The programatically applied height of the `GradientActivityIndicatorView`.
        static let height: CGFloat = 3
    }

    // MARK: - Private properties

    private let gradientProgressIndicatorView = GradientActivityIndicatorView()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientProgressIndicatorView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        gradientProgressIndicatorView.fadeOut()
    }

    @IBAction private func showButtonTouchUpInside(_: Any) {
        gradientProgressIndicatorView.fadeIn()
    }

    @IBAction private func hideButtonTouchUpInside(_: Any) {
        gradientProgressIndicatorView.fadeOut()
    }

    // MARK: - Private methods

    private func setupGradientProgressIndicatorView() {
        guard let navigationBar = navigationController?.navigationBar else { return }

        gradientProgressIndicatorView.fadeOut(duration: 0)

        gradientProgressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.addSubview(gradientProgressIndicatorView)

        NSLayoutConstraint.activate([
            gradientProgressIndicatorView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            gradientProgressIndicatorView.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),

            gradientProgressIndicatorView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            gradientProgressIndicatorView.heightAnchor.constraint(equalToConstant: Config.height),
        ])
    }
}
