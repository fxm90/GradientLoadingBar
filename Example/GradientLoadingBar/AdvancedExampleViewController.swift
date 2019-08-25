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

    @IBOutlet private var interfaceBuilderButton: BlueBorderedButton!
    @IBOutlet private var programaticallyButton: BlueBorderedButton!

    @IBOutlet private var gradientActivityIndicatorView: GradientActivityIndicatorView!

    // MARK: - Private properties

    // swiftlint:disable:next identifier_name
    private let programaticallyGradientActivityIndicatorView: GradientActivityIndicatorView = {
        let gradientActivityIndicatorView = GradientActivityIndicatorView()
        gradientActivityIndicatorView.alpha = 0.0
        gradientActivityIndicatorView.isHidden = true

        // Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        gradientActivityIndicatorView.gradientColorList = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1)
        ]

        return gradientActivityIndicatorView
    }()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomColorsGradientActivityIndicatorView()
    }

    @IBAction func interfaceBuilderButtonTouchUpInside(_: Any) {
        if gradientActivityIndicatorView.isHidden {
            gradientActivityIndicatorView.fadeIn()
        } else {
            gradientActivityIndicatorView.fadeOut()
        }
    }

    @IBAction func programaticallyButtonTouchUpInside(_: Any) {
        if programaticallyGradientActivityIndicatorView.isHidden {
            programaticallyGradientActivityIndicatorView.fadeIn()
        } else {
            programaticallyGradientActivityIndicatorView.fadeOut()
        }
    }

    // MARK: - Private methods

    func setupCustomColorsGradientActivityIndicatorView() {
        programaticallyGradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        programaticallyButton.addSubview(programaticallyGradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            programaticallyGradientActivityIndicatorView.leftAnchor.constraint(equalTo: programaticallyButton.leftAnchor),
            programaticallyGradientActivityIndicatorView.rightAnchor.constraint(equalTo: programaticallyButton.rightAnchor),

            programaticallyGradientActivityIndicatorView.bottomAnchor.constraint(equalTo: programaticallyButton.bottomAnchor),
            programaticallyGradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
    }
}

// MARK: - UIBarPositioningDelegate

// Notice: Delegate is setted-up via storyboard.
extension AdvancedExampleViewController: UINavigationBarDelegate {
    func position(for _: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
