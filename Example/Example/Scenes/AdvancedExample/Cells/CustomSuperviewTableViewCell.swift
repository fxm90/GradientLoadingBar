//
//  CustomSuperviewTableViewCell.swift
//  Example
//
//  Created by Felix Mau on 15.04.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import GradientLoadingBar

final class CustomSuperviewTableViewCell: UITableViewCell {

    // MARK: - Config

    private enum Config {
        static let height: CGFloat = 3
    }

    // MARK: - Outlets

    @IBOutlet private var toggleButton: UIButton!

    // MARK: - Public properties

    static let reuseIdentifier = "CustomSuperviewViewCell"

    // MARK: - Private properties

    private let gradientActivityIndicatorView = GradientActivityIndicatorView()

    // MARK: - Public methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setupGradientActivityIndicatorView()
    }

    // MARK: - Private methods

    private func setupGradientActivityIndicatorView() {
        gradientActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.addSubview(gradientActivityIndicatorView)

        NSLayoutConstraint.activate([
            gradientActivityIndicatorView.leadingAnchor.constraint(equalTo: toggleButton.leadingAnchor),
            gradientActivityIndicatorView.trailingAnchor.constraint(equalTo: toggleButton.trailingAnchor),

            gradientActivityIndicatorView.bottomAnchor.constraint(equalTo: toggleButton.bottomAnchor),
            gradientActivityIndicatorView.heightAnchor.constraint(equalToConstant: Config.height),
        ])
    }

    @IBAction private func toggleButtonTouchUpInside(_: Any) {
        if gradientActivityIndicatorView.isHidden {
            gradientActivityIndicatorView.fadeIn()
        } else {
            gradientActivityIndicatorView.fadeOut()
        }
    }
}
