//
//  ViewController.swift
//  GradientLoadingBar
//
//  Created by fxm90 on 09/30/2017.
//  Copyright (c) 2017 fxm90. All rights reserved.
//

import UIKit
import GradientLoadingBar

class ViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var hideButton: UIButton!

    @IBOutlet weak var customSuperviewButton: UIButton!
    @IBOutlet weak var customContraintsButton: UIButton!

    let gradientLoadingBar =
        GradientLoadingBar.sharedInstance()

    var customSuperviewLoadingBar: GradientLoadingBar?
    var customContraintsLoadingBar: BottomGradientLoadingBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Style buttons
        let basicButtonList = [showButton, toggleButton, hideButton]
        basicButtonList.forEach { (button: UIButton!) in
            button.layer.cornerRadius = 4.0
            button.tintColor = UIColor.white
            button.backgroundColor = UIColor.aquaBlue
        }

        let customButtonList = [customSuperviewButton, customContraintsButton]
        customButtonList.forEach { (button: UIButton!) in
            button.layer.borderColor = UIColor.aquaBlue.cgColor
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 4.0

            button.tintColor = UIColor.aquaBlue
            button.backgroundColor = UIColor.clear
        }

        // Add gradient loading bar to button.
        customSuperviewLoadingBar = GradientLoadingBar(onView: customSuperviewButton)
        customSuperviewButton.clipsToBounds = true

        // Add custom gradient loading bar to button.
        customContraintsLoadingBar = BottomGradientLoadingBar(onView: customContraintsButton)
        customContraintsButton.clipsToBounds = true
    }

    // MARK: - User actions

    @IBAction func onShowButtonTouchUpInside(_ sender: Any) {
        gradientLoadingBar.show()
    }

    @IBAction func onToggleButtonTouchUpInside(_ sender: Any) {
        gradientLoadingBar.toggle()
    }

    @IBAction func onHideButtonTouchUpInside(_ sender: Any) {
        gradientLoadingBar.hide()
    }

    @IBAction func onCustomSuperviewButtonTouchUpInside(_ sender: Any) {
        customSuperviewLoadingBar!.toggle()
    }

    @IBAction func onCustomContraintsButtonTouchUpInside(_ sender: Any) {
        customContraintsLoadingBar!.toggle()
    }
}

// MARK: - Custom Gradient Loading Bar

class BottomGradientLoadingBar: GradientLoadingBar {
    override func setupConstraints() {
        guard let superview = superview else { return }

        gradientView.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true

        gradientView.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
    }
}

// MARK: - Helper

fileprivate extension UIColor {
    static let aquaBlue = UIColor(hexString: "#4990e2")
}
