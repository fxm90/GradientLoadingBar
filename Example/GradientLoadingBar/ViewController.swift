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

    let buttonTintColor = UIColor.white
    let buttonBackgroundColor = UIColor(hexString: "#4990e2")

    let gradientLoadingBar = GradientLoadingBar.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        showButton.layer.cornerRadius = 4.0
        showButton.tintColor = buttonTintColor
        showButton.backgroundColor = buttonBackgroundColor

        toggleButton.layer.cornerRadius = 4.0
        toggleButton.tintColor = buttonTintColor
        toggleButton.backgroundColor = buttonBackgroundColor

        hideButton.layer.cornerRadius = 4.0
        hideButton.tintColor = buttonTintColor
        hideButton.backgroundColor = buttonBackgroundColor
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
}
