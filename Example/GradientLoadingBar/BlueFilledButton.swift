//
//  BlueButton.swift
//  GradientLoadingBar_Example
//
//  Created by Felix Mau on 29.08.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class BlueFilledButton: UIButton {
    // MARK: - Initializer

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
        tintColor = .white
        backgroundColor = .aquaBlue

        layer.cornerRadius = 4.0
    }
}
