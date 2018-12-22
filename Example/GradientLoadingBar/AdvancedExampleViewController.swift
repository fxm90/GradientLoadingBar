//
//  AdvancedExampleViewController.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/30/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

class AdvancedExampleViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var customSuperviewButton: BlueBorderedButton!
    @IBOutlet private var customColorsButton: BlueBorderedButton!

    // MARK: - Private properties

    private var buttonGradientLoadingBar: GradientLoadingBar?
    private var customColorsGradientLoadingBar: GradientLoadingBar?

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonGradientLoadingBar = GradientLoadingBar(height: 3.0,
                                                      onView: customSuperviewButton)

        // Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        let gradientColorList = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1)
        ]
        customColorsGradientLoadingBar = BottomGradientLoadingBar(height: 3.0,
                                                                  gradientColorList: gradientColorList,
                                                                  onView: customColorsButton)
    }

    @IBAction func customSuperviewButtonTouchUpInside(_: Any) {
        buttonGradientLoadingBar?.toggle()
    }

    @IBAction func customGradientColorsButtonTouchUpInside(_: Any) {
        customColorsGradientLoadingBar?.toggle()
    }
}

// MARK: - UIBarPositioningDelegate

// Notice: Delegate is setted-up via storyboard.
extension AdvancedExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
