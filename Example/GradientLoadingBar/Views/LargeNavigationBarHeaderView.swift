//
//  LargeNavigationBarHeaderView.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 23.09.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
final class LargeNavigationBarHeaderView: UIView {
    // MARK: - Public properties

    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    @IBInspectable var prompt: String = "" {
        didSet {
            promptLabel.text = prompt
        }
    }

    // MARK: - Private properties

    private let titleLabel = UILabel(frame: .zero)

    private let promptLabel = UILabel(frame: .zero)

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        setupTitleLabel()
        setupPromptLabel()
    }

    private func setupTitleLabel() {
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
        titleLabel.font = UIFont.systemFont(ofSize: fontDescriptor.pointSize, weight: .bold)
        titleLabel.textColor = .label

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),

            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
        ])
    }

    private func setupPromptLabel() {
        promptLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        promptLabel.textAlignment = .center
        promptLabel.textColor = .label

        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(promptLabel)

        NSLayoutConstraint.activate([
            promptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            promptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),

            promptLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9.5),
        ])
    }
}
