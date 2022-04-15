//
//  CustomColorsTableViewCell.swift
//  Example
//
//  Created by Felix Mau on 15.04.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit

final class CustomColorsTableViewCell: UITableViewCell {
    // MARK: - Public properties

    static let reuseIdentifier = "CustomColorsTableViewCell"

    var tapHandler: (() -> Void)?

    // MARK: - Private methods

    @IBAction private func customColorsButtonTouchUpInside(_: Any) {
        tapHandler?()
    }
}
