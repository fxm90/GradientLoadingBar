//
//  InterfaceBuilderExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 12.10.19.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class InterfaceBuilderExampleViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var gradientActivityIndicatorView: GradientActivityIndicatorView!

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        gradientActivityIndicatorView.fadeOut()
    }

    @IBAction private func showButtonTouchUpInside(_: Any) {
        gradientActivityIndicatorView.fadeIn()
    }

    @IBAction private func hideButtonTouchUpInside(_: Any) {
        gradientActivityIndicatorView.fadeOut()
    }
}
