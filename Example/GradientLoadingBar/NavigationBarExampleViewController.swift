//
//  NavigationBarExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 29.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GradientLoadingBar

class NavigationBarExampleViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var navigationBar: UINavigationBar!

    // MARK: - Private properties

    private var gradientLoadingBar: BottomGradientLoadingBar?

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        gradientLoadingBar = BottomGradientLoadingBar(onView: navigationBar)
    }

    @IBAction func showButtonTouchUpInside(_: Any) {
        gradientLoadingBar?.show()
    }

    @IBAction func toggleButtonTouchUpInside(_: Any) {
        gradientLoadingBar?.toggle()
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        gradientLoadingBar?.hide()
    }
}

// MARK: - UIBarPositioningDelegate

// Notice: Delegate is setted-up via storyboard.
extension NavigationBarExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
