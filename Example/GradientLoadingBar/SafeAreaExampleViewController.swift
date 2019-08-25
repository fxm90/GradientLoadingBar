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

    private let safeAreaGradientLoadingBar = GradientLoadingBar(height: 3.0,
                                                                isRelativeToSafeArea: false)

    // MARK: - Public methods

    @IBAction func showButtonTouchUpInside(_: Any) {
        safeAreaGradientLoadingBar.show()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        safeAreaGradientLoadingBar.hide()
    }
}

// MARK: - UIBarPositioningDelegate

// Notice: Delegate is setted-up via storyboard.
extension SafeAreaExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
