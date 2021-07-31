//
//  SafeAreaExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 30.08.18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class SafeAreaExampleViewController: UIViewController {
    // MARK: - Private properties

    private let gradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)

    private let notchGradientLoadingBar = NotchGradientLoadingBar(isRelativeToSafeArea: false)

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        gradientLoadingBar.fadeOut()
        notchGradientLoadingBar.fadeOut()
    }

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
