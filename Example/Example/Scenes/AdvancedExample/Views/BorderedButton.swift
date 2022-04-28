//
//  BorderedButton.swift
//  Example
//
//  Created by Felix Mau on 15.04.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit

@IBDesignable
final class BorderedButton: UIButton {

    // MARK: - Config

    private enum Config {
        static let borderColor = #colorLiteral(red: 0.2862745098, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 4
    }

    // MARK: - Instance Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        backgroundColor = .clear
        tintColor = Config.borderColor

        layer.borderColor = Config.borderColor.cgColor
        layer.borderWidth = Config.borderWidth
        layer.cornerRadius = Config.cornerRadius
        layer.masksToBounds = true
    }
}
