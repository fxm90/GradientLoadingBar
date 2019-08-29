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

    // MARK: - Private properties

    /// The layer holding the gradient.
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.anchorPoint = .zero
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1.0, y: 0.0)

        return layer
    }()

    /// The progress animation.
    ///
    /// - Note: `fromValue` and `duration` are updated from the view-model.
    private let animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 0
        animation.toValue = 0
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.infinity
        animation.duration = 0

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

    open override func layoutSubviews() {
        super.layoutSubviews()

        viewModel.bounds = bounds
    }

    open override func point(inside _: CGPoint, with _: UIEvent?) -> Bool {
        // Passing all touches to the next view (if any), in the view stack.
        return false
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        // Not sure why we need to set this again to make it work in the interface builder.
        layer.masksToBounds = true
    }

    // MARK: - Private methods

    private func commonInit() {
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true

        viewModel.delegate = self
        bindViewModelToView()
    }

    private func bindViewModelToView() {
        viewModel.isAnimatingProgress.subscribeDistinct { [weak self] newIsAnimatingProgress, _ in
            self?.updateProgressAnimation(isAnimating: newIsAnimatingProgress)
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerFrame.subscribeDistinct { [weak self] newGradientLayerFrame, _ in
            self?.gradientLayer.frame = newGradientLayerFrame
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerAnimationFromValue.subscribeDistinct { [weak self] newGradientLayerAnimationFromValue, _ in
            self?.animation.fromValue = newGradientLayerAnimationFromValue
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerAnimationDuration.subscribeDistinct { [weak self] newGradientLayerAnimationDuration, _ in
            self?.animation.duration = newGradientLayerAnimationDuration
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerColors.subscribeDistinct { [weak self] newGradientLayerColors, _ in
            self?.gradientLayer.colors = newGradientLayerColors
        }.disposed(by: &disposeBag)
    }

    private func updateProgressAnimation(isAnimating: Bool) {
        if isAnimating {
            gradientLayer.add(animation, forKey: GradientActivityIndicatorView.progressAnimationKey)
        } else {
            gradientLayer.removeAnimation(forKey: GradientActivityIndicatorView.progressAnimationKey)
        }
    }
}

// MARK: - `GradientActivityIndicatorViewModelDelegate` conformance

extension GradientActivityIndicatorView: GradientActivityIndicatorViewModelDelegate {
    func restartAnimation() {
        updateProgressAnimation(isAnimating: false)
        updateProgressAnimation(isAnimating: true)
    }
}
