//
//  UIView+hasTopSafeAreaInset.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 26.12.17.
//

import UIKit

extension UIView {

    /// Flag determining whether a view has a top safe area inset.
    @available(iOS 11.0, *)
    var hasTopSafeAreaInset: Bool {
        return safeAreaInsets.top > 0.0
    }
}
