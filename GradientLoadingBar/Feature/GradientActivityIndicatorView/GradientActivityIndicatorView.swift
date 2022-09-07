//
//  GradientActivityIndicatorView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12.10.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import LightweightObservable
import UIKit

@IBDesignable
open class GradientActivityIndicatorView: UIView {

    // MARK: - Config

    /// Animation-Key for the progress animation.
    private enum Config {
        static let progressAnimationKey = "GradientActivityIndicatorView--progressAnimation"
    }

    // MARK: - Public properties

    /// Boolean flag, whether the view is currently hidden.
    override open var isHidden: Bool {
        didSet {
            viewModel.isHidden = isHidden
        }
    }

    /// Colors used for the gradient.
    public var gradientColors: [UIColor] {
        get { viewModel.gradientColors }
        set { viewModel.gradientColors = newValue }
    }

    /// Duration for the progress animation.
    public var progressAnimationDuration: TimeInterval {
        get { viewModel.progressAnimationDuration }
        set { viewModel.progressAnimationDuration = newValue }
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
    /// - Note: `fromValue` and `duration` are updated from the view-model subscription.
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

    // MARK: - Instance Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    // MARK: - Public methods

    override open func layoutSubviews() {
        super.layoutSubviews()

        viewModel.bounds = bounds
    }

    override open func point(inside _: CGPoint, with _: UIEvent?) -> Bool {
        // Passing all touches to the next view (if any), in the view stack.
        false
    }

    // MARK: - Private methods

    private func commonInit() {
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true

        bindViewModelToView()
    }

    private func bindViewModelToView() {
        viewModel.isAnimating.subscribeDistinct { [weak self] isAnimating, _ in
            self?.updateProgressAnimation(isAnimating: isAnimating)
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerSizeUpdate.subscribeDistinct { [weak self] sizeUpdate, _ in
            self?.gradientLayer.frame = sizeUpdate.frame
            self?.animation.fromValue = sizeUpdate.fromValue
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerColors.subscribeDistinct { [weak self] gradientColors, _ in
            self?.gradientLayer.colors = gradientColors
        }.disposed(by: &disposeBag)

        viewModel.gradientLayerAnimationDuration.subscribeDistinct { [weak self] animationDuration, _ in
            self?.animation.duration = animationDuration
        }.disposed(by: &disposeBag)
    }

    private func updateProgressAnimation(isAnimating: Bool) {
        if isAnimating {
            gradientLayer.add(animation, forKey: Config.progressAnimationKey)
        } else {
            gradientLayer.removeAnimation(forKey: Config.progressAnimationKey)
        }
    }
}
