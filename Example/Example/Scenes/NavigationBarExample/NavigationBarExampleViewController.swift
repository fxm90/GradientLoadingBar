//
//  NavigationBarExampleViewController.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import SwiftUI
import GradientLoadingBar

final class NavigationBarExampleViewController: UIViewController {
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

        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = barButtonItem

        setupGradientProgressIndicatorView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Reset any possible visible loading bar.
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

    @IBAction private func doneButtonTapped(_: Any) {
        dismiss(animated: true)
    }

    @IBAction private func showButtonTouchUpInside(_: Any) {
        gradientProgressIndicatorView.fadeIn()
    }

    @IBAction private func hideButtonTouchUpInside(_: Any) {
        gradientProgressIndicatorView.fadeOut()
    }
}

// MARK: - Helpers

struct NavigationBarExampleView: View {
    var body: some View {
        StoryboardView(name: "NavigationBarExample")
    }
}
