//
//  GradientActivityIndicatorView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12/10/16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import UIKit
import LightweightObservable

@IBDesignable
open class GradientActivityIndicatorView: UIView {
    // MARK: - Config

    /// Animation-Key for the progress animation.
    private static let progressAnimationKey = "GradientActivityIndicatorView--progressAnimation"

    // MARK: - Public properties

    /// Boolean flag, whether the view is currently hidden.
    open override var isHidden: Bool {
        didSet {
            viewModel.isHidden = isHidden
        }
    }

    /// Colors used for the gradient.
    public var gradientColors: [UIColor] {
        get {
            return viewModel.gradientColors
        }
        set {
            viewModel.gradientColors = newValue
        }
    }

    /// Duration for the progress animation.
    public var progressAnimationDuration: TimeInterval {
        get {
            return viewModel.progressAnimationDuration
        }
        set {
            viewModel.progressAnimationDuration = newValue
        }
    }

    /// In order to prevent adding another sublayer and keeping the frame up-to-date, we
    /// simply overwrite the `layerClass` and use a `CAGradientLayer` for this view.
    open override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: - Private properties

    /// The layer holding the gradient.
    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }

    /// The animation used to show the "progress".
    private let progressAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "locations")
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.infinity
        animation.fillMode = .forwards

        return animation
    }()

    /// View model containing all logic related to this view.
    private let viewModel = GradientActivityIndicatorViewModel()

    /// The dispose bag for the observables.
    private var disposeBag = DisposeBag()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Public methods

    open override func point(inside _: CGPoint, with _: UIEvent?) -> Bool {
        // Passing all touches to the next view (if any), in the view stack.
        return false
    }

    // MARK: - Private methods

    private func commonInit() {
        gradientLayer?.startPoint = .zero
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.0)

        bindViewModelToView()
    }

    private func bindViewModelToView() {
        viewModel.gradientLayerColors.subscribeDistinct { [weak self] newGradientLayerColors, _ in
            self?.gradientLayer?.colors = newGradientLayerColors
        }.disposed(by: &disposeBag)

        viewModel.colorLocationInitialRow.subscribeDistinct { [weak self] newColorLocationInitialRow, _ in
            self?.gradientLayer?.locations = newColorLocationInitialRow
        }.disposed(by: &disposeBag)

        viewModel.colorLocationMatrix.subscribeDistinct { [weak self] newColorLocationMatrix, _ in
            self?.progressAnimation.values = newColorLocationMatrix
        }.disposed(by: &disposeBag)

        viewModel.animationDuration.subscribeDistinct { [weak self] newAnimationDuration, _ in
            self?.progressAnimation.duration = newAnimationDuration
        }.disposed(by: &disposeBag)

        viewModel.isAnimating.subscribeDistinct { [weak self] newIsAnimating, _ in
            self?.updateAnimation(isAnimating: newIsAnimating)
        }.disposed(by: &disposeBag)
    }

    private func updateAnimation(isAnimating: Bool) {
        if isAnimating {
            gradientLayer?.add(progressAnimation, forKey: GradientActivityIndicatorView.progressAnimationKey)
        } else {
            gradientLayer?.removeAnimation(forKey: GradientActivityIndicatorView.progressAnimationKey)
        }
    }
}
