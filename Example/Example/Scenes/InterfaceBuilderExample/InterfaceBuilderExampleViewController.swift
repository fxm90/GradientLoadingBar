//
//  InterfaceBuilderExampleViewController.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import SwiftUI
import GradientLoadingBar

final class InterfaceBuilderExampleViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var gradientActivityIndicatorView: GradientActivityIndicatorView!

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Reset any possible visible loading bar.
        gradientActivityIndicatorView.fadeOut()
    }

    // MARK: - Private methods

    @IBAction private func showButtonTouchUpInside(_: Any) {
        gradientActivityIndicatorView.fadeIn()
    }

    @IBAction private func hideButtonTouchUpInside(_: Any) {
        gradientActivityIndicatorView.fadeOut()
    }
}

// MARK: - Helpers

struct InterfaceBuilderExampleView: View {
    var body: some View {
        StoryboardView(name: "InterfaceBuilderExample")
            .navigationTitle("🎨 Interface Builder Example")
    }
}
