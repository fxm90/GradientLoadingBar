//
//  AdvancedExampleViewController.swift
//  Example
//
//  Created by Felix Mau on 07.03.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import SwiftUI
import GradientLoadingBar

final class AdvancedExampleViewController: UIViewController {
    // MARK: - Config

    private enum Config {
        /// The programatically applied height of the `GradientActivityIndicatorView`.
        static let height: CGFloat = 3.5
    }

    // MARK: - Outlets

    @IBOutlet private var customSuperviewButton: BorderedButton!
    @IBOutlet private var customColorsButton: UIButton!

    // MARK: - Private properties

    private let customSuperviewGradientActivityIndicatorView = GradientActivityIndicatorView()
    private let customColorsGradientLoadingBar = GradientLoadingBar()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCustomSuperviewGradientActivityIndicatorView()
        setupCustomColorsGradientLoadingBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Reset any possible visible loading bar.
        customSuperviewGradientActivityIndicatorView.fadeOut()
        customColorsGradientLoadingBar.fadeOut()
    }

    // MARK: - Private methods

    private func setupCustomSuperviewGradientActivityIndicatorView() {
        customSuperviewGradientActivityIndicatorView.isHidden = true
        customSuperviewGradientActivityIndicatorView.alpha = 0

        customSuperviewGradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        customSuperviewButton.addSubview(customSuperviewGradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            customSuperviewGradientActivityIndicatorView.leadingAnchor.constraint(equalTo: customSuperviewButton.leadingAnchor),
            customSuperviewGradientActivityIndicatorView.trailingAnchor.constraint(equalTo: customSuperviewButton.trailingAnchor),

            customSuperviewGradientActivityIndicatorView.topAnchor.constraint(equalTo: customSuperviewButton.topAnchor),
            customSuperviewGradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: Config.height),
        ])
    }

    private func setupCustomColorsGradientLoadingBar() {
        // Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        customColorsGradientLoadingBar.gradientColors = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
        ]
    }

    @IBAction private func toggleCustomSuperviewButtonTouchUpInside(_: Any) {
        if customSuperviewGradientActivityIndicatorView.isHidden {
            customSuperviewGradientActivityIndicatorView.fadeIn()
        } else {
            customSuperviewGradientActivityIndicatorView.fadeOut()
        }
    }

    @IBAction private func toggleCustomColorsButtonTouchUpInside(_: Any) {
        // TODO: Add `isHidden` shortcut
        if customColorsGradientLoadingBar.gradientActivityIndicatorView.isHidden {
            customColorsGradientLoadingBar.fadeIn()
        } else {
            customColorsGradientLoadingBar.fadeOut()
        }
    }
}

// MARK: - Helpers

///
///
@IBDesignable
final class BorderedButton: UIButton {
    private enum Config {
        static let borderColor = #colorLiteral(red: 0.2862745098, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        tintColor = Config.borderColor

        layer.borderColor = Config.borderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
}

struct AdvancedExampleView: View {
    var body: some View {
        StoryboardView(name: "AdvancedExample")
            .navigationTitle("🚀 Advanced Example")
    }
}
