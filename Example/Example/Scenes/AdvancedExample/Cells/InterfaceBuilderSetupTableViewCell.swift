//
//  InterfaceBuilderSetupTableViewCell.swift
//  Example
//
//  Created by Felix Mau on 15.04.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

final class InterfaceBuilderSetupTableViewCell: UITableViewCell {

    // MARK: - Config

    private enum Config {
        static let animationDuration: TimeInterval = 0.5
    }

    // MARK: - Outlets

    @IBOutlet private var gradientActivityIndicator: GradientActivityIndicatorView!

    // MARK: - Public properties

    static let reuseIdentifier = "InterfaceBuilderSetupTableViewCell"

    // MARK: - Private methods

    @IBAction private func toggleIBSetupButtonTouchUpInside(_: Any) {
        // We explicitly "only" reduce the alpha here, as calling `fadeIn()` / `fadeOut()` would update the `isHidden`
        // flag accordingly. This would then lead to a height-update of the parent stack view.
        UIView.animate(withDuration: Config.animationDuration) {
            if self.gradientActivityIndicator.alpha > 0 {
                self.gradientActivityIndicator.alpha = 0
            } else {
                self.gradientActivityIndicator.alpha = 1
            }
        }
    }
}
