//
//  BasicExampleViewController.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import SwiftUI
import GradientLoadingBar

final class BasicExampleViewController: UIViewController {

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Reset any possible visible loading bar.
        GradientLoadingBar.shared.fadeOut()
    }

    // MARK: - Private methods

    @IBAction private func showButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeIn()
    }

    @IBAction private func hideButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeOut()
    }
}

// MARK: - Helper

struct BasicExampleView: View {
    var body: some View {
        StoryboardView(name: "BasicExample")
            .navigationTitle("🏡 Basic Example")
    }
}
