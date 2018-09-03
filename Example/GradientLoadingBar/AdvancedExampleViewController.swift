//
//  AdvancedExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 29.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import GradientLoadingBar

class AdvancedExampleViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var customSuperviewButton: BlueBorderedButton!
    @IBOutlet var customGradientColorsButton: BlueBorderedButton!

    // MARK: - Private properties

    private var buttonGradientLoadingBar: GradientLoadingBar?
    private var customGradientColorsGradientLoadingBar: GradientLoadingBar?

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonGradientLoadingBar = GradientLoadingBar(height: 3.0,
                                                      onView: customSuperviewButton)

        // Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        customGradientColorsGradientLoadingBar = BottomGradientLoadingBar(height: 3.0,
                                                                          gradientColorList: [
                                                                              UIColor(hex: "#f2526e"),
                                                                              UIColor(hex: "#f17a97"),
                                                                              UIColor(hex: "#f3bcc8"),
                                                                              UIColor(hex: "#6dddf2"),
                                                                              UIColor(hex: "#c1f0f4")
                                                                          ],
                                                                          onView: customGradientColorsButton)
    }

    @IBAction func customSuperviewButtonTouchUpInside(_: Any) {
        buttonGradientLoadingBar?.toggle()
    }

    @IBAction func customGradientColorsButtonTouchUpInside(_: Any) {
        customGradientColorsGradientLoadingBar?.toggle()
    }
}

// MARK: - UIBarPositioningDelegate

// Notice: Delegate is setted-up via storyboard.
extension AdvancedExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
