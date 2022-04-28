//
//  StoryboardView.swift
//  Example
//
//  Created by Felix Mau on 02.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

struct StoryboardView: UIViewControllerRepresentable {

    // MARK: - Public properties

    let name: String

    // MARK: - Public methods

    func makeUIViewController(context _: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("⚠️ – Could not instantiate initial view controller for storyboard with name `\(name)`.")
        }

        return viewController
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}
