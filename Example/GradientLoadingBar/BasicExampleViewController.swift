//
//  BasicExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 09/30/17.
//  Copyright © 2017 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class BasicExampleViewController: UIViewController {
    // MARK: - Public methods

    @IBAction func showButtonTouchUpInside(_: Any) {
        let gradientLoadingBar = GradientLoadingBar.shared
        gradientLoadingBar.show()
    }

    @IBAction func toggleButtonTouchUpInside(_: Any) {
        let gradientLoadingBar = GradientLoadingBar.shared
        gradientLoadingBar.toggle()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        let gradientLoadingBar = GradientLoadingBar.shared
        gradientLoadingBar.hide()
    }
}

// MARK: - UIBarPositioningDelegate

// Notice: Delegate is setted-up via storyboard.
extension BasicExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
