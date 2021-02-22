//
//  BasicExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 30.09.17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class BasicExampleViewController: UIViewController {
    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        GradientLoadingBar.shared.fadeOut()
    }

    @IBAction func showButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeIn()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeOut()
    }
}
