//
//  AdvancedExampleTableViewController.swift
//  Example
//
//  Created by Felix Mau on 12.04.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import UIKit
import SwiftUI
import GradientLoadingBar

final class AdvancedExampleTableViewController: UITableViewController {
    // MARK: - Config

    private enum Config {
        /// The custom gradient colors we use.
        /// Source: https://color.adobe.com/Pink-Flamingo-color-theme-10343714/
        static let gradientColors = [
            #colorLiteral(red: 0.9490196078, green: 0.3215686275, blue: 0.431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.4784313725, blue: 0.5921568627, alpha: 1), #colorLiteral(red: 0.9529411765, green: 0.737254902, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.4274509804, green: 0.8666666667, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.7568627451, green: 0.9411764706, blue: 0.9568627451, alpha: 1),
        ]

        ///
        static let firstSectionHeaderHeight: CGFloat = 48

        ///
        static let defaultSectionHeaderHeight: CGFloat = 32
    }

    // MARK: - Types

    private enum Section: CaseIterable {
        case customColors
        case interfaceBuilderSetup
        case customSuperview

        var cellIdentifier: String {
            switch self {
            case .customColors:
                return CustomColorsTableViewCell.reuseIdentifier

            case .interfaceBuilderSetup:
                return InterfaceBuilderSetupTableViewCell.reuseIdentifier

            case .customSuperview:
                return CustomSuperviewTableViewCell.reuseIdentifier
            }
        }

        var sectionTitle: String {
            switch self {
            case .customColors:
                return "Custom Colors"

            case .interfaceBuilderSetup:
                return "Interface Builder Setup"

            case .customSuperview:
                return "Custom Superview"
            }
        }

        var sectionHeaderHeight: CGFloat {
            switch self {
            case .customColors:
                return Config.firstSectionHeaderHeight

            case .interfaceBuilderSetup, .customSuperview:
                return Config.defaultSectionHeaderHeight
            }
        }
    }

    // MARK: - Private properties

    private let gradientLoadingBar = GradientLoadingBar()

    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGroupedBackground

        gradientLoadingBar.gradientColors = Config.gradientColors
    }

    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section.allCases[indexPath.section]
        switch section {
        case .customColors:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath) as? CustomColorsTableViewCell else {
                fatalError("⚠️ – Invalid table view setup. Expected to have `CustomColorsTableViewCell` at this point!")
            }

            cell.tapHandler = { [weak self] in
                if self?.gradientLoadingBar.isHidden == true {
                    self?.gradientLoadingBar.fadeIn()
                } else {
                    self?.gradientLoadingBar.fadeOut()
                }
            }

            return cell

        case .interfaceBuilderSetup, .customSuperview:
            return tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        }
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section.allCases[section].sectionTitle
    }

    override func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Section.allCases[section].sectionHeaderHeight
    }
}

// MARK: - Helper

struct AdvancedExampleView: View {
    var body: some View {
        StoryboardView(name: "AdvancedExample")
            .navigationTitle("🚀 Advanced Example")
            .edgesIgnoringSafeArea(.bottom)
    }
}
