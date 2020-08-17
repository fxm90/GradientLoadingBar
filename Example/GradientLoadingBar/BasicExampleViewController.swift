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

    @IBOutlet private var slider: UISlider!

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        slider.isHidden = true
        GradientLoadingBar.shared.fadeOut()
    }

    @IBAction func showButtonTouchUpInside(_: Any) {
        GradientLoadingBar.shared.fadeIn()

        slider.isHidden = false
        GradientLoadingBar.shared.setProgress(CGFloat(slider.value))
    }

    @IBAction func hideButtonTouchUpInside(_: Any) {
        slider.isHidden = true
        GradientLoadingBar.shared.fadeOut()
    }

    @IBAction func chnageSliderValue(_ sender: UISlider) {
        GradientLoadingBar.shared.setProgress(CGFloat(sender.value))
    }
}
