//
//  SafeAreaExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/30/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class SafeAreaExampleViewController: UIViewController {
    // MARK: - Private properties

    private let notchGradientLoadingBar = NotchGradientLoadingBar(height: 4)

    // MARK: - Public methods

    @IBAction func showButtonTouchUpInside(_: Any) {
        notchGradientLoadingBar.fadeIn()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        notchGradientLoadingBar.fadeOut()
    }
}
