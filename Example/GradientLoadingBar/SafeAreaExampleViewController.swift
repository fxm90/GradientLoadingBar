//
//  SafeAreaExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 30.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GradientLoadingBar

class SafeAreaExampleViewController: UIViewController {
    // MARK: - Private properties

    let safeAreaGradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)

    // MARK: - Public methods

    @IBAction func showButtonTouchUpInside(_: Any) {
        safeAreaGradientLoadingBar.show()
    }

    @IBAction func toggleButtonTouchUpInside(_: Any) {
        safeAreaGradientLoadingBar.toggle()
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
