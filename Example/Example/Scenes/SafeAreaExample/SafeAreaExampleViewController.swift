//
//  SafeAreaExampleViewController.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import GradientLoadingBar
import SwiftUI
import UIKit

final class SafeAreaExampleViewController: UIViewController {

    // MARK: - Private properties

    private let gradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)
    private let notchGradientLoadingBar = NotchGradientLoadingBar(isRelativeToSafeArea: false)

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Reset any possible visible loading bar.
        gradientLoadingBar.fadeOut()
        notchGradientLoadingBar.fadeOut()
    }

    // MARK: - Private methods

    @IBAction private func showBasicBarButtonTouchUpInside(_: Any) {
        gradientLoadingBar.fadeIn()
    }

    @IBAction private func hideBasicBarButtonTouchUpInside(_: Any) {
        gradientLoadingBar.fadeOut()
    }

    @IBAction private func showNotchBarButtonTouchUpInside(_: Any) {
        notchGradientLoadingBar.fadeIn()
    }

    @IBAction private func hideNotchBarButtonTouchUpInside(_: Any) {
        notchGradientLoadingBar.fadeOut()
    }
}

// MARK: - Helper

struct SafeAreaExampleView: View {
    var body: some View {
        StoryboardView(name: "SafeAreaExample")
            .navigationTitle("📲 Safe Area Example")
    }
}
