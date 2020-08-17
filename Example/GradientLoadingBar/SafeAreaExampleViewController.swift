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

    @IBOutlet private var slider: UISlider!

    private let gradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)

    private let notchGradientLoadingBar = NotchGradientLoadingBar(isRelativeToSafeArea: false)

    // MARK: - Public methods

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        slider.isHidden = true
        gradientLoadingBar.fadeOut()
        notchGradientLoadingBar.fadeOut()
    }

    @IBAction func showBasicBarButtonTouchUpInside(_: Any) {
        gradientLoadingBar.fadeIn()
    }

    @IBAction func hideBasicBarButtonTouchUpInside(_: Any) {
        gradientLoadingBar.fadeOut()
    }

    @IBAction func showNotchBarButtonTouchUpInside(_: Any) {
        slider.isHidden = false
        notchGradientLoadingBar.fadeIn()
        notchGradientLoadingBar.setProgress(CGFloat(slider.value))
    }

    @IBAction func hideNotchBarButtonTouchUpInside(_: Any) {
        slider.isHidden = true
        notchGradientLoadingBar.fadeOut()
    }

    @IBAction func chnageSlider(_ sender: UISlider) {
        notchGradientLoadingBar.setProgress(CGFloat(sender.value))
    }
}
