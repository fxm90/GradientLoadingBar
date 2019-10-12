//
//  BlueFilledButton.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 08/29/18.
//  Copyright © 2018 Felix Mau. All rights reserved.
//

import UIKit

@IBDesignable
final class BlueFilledButton: UIButton {
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        commonInit()
    }

    // MARK: - Private methods

    private func commonInit() {
        tintColor = .white
        backgroundColor = UIColor.CustomColors.blue

        layer.cornerRadius = 4.0
    }
}
