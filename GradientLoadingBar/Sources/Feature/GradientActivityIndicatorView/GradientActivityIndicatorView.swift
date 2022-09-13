//
//  GradientActivityIndicatorView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 12.10.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Combine
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
        layer.endPoint = CGPoint(x: 1, y: 0)

        return layer
    }()

    /// The progress animation.
    ///
    /// - Note: `fromValue` and `duration` are updated from the view-model subscription.
    private let progressAnimation: CABasicAnimation = {
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
    private var subscriptions = Set<AnyCancellable>()

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
        viewModel.isAnimating.sink { [weak self] isAnimating in
            self?.updateProgressAnimation(isAnimating: isAnimating)
        }.store(in: &subscriptions)

        viewModel.gradientLayerSizeUpdate.sink { [weak self] sizeUpdate in
            self?.gradientLayer.frame = sizeUpdate.frame
            self?.progressAnimation.fromValue = sizeUpdate.fromValue
        }.store(in: &subscriptions)

        viewModel.gradientLayerColors.sink { [weak self] gradientColors in
            self?.gradientLayer.colors = gradientColors
        }.store(in: &subscriptions)

        viewModel.gradientLayerAnimationDuration.sink { [weak self] animationDuration in
            self?.progressAnimation.duration = animationDuration
        }.store(in: &subscriptions)
    }

    private func updateProgressAnimation(isAnimating: Bool) {
        if isAnimating {
            gradientLayer.add(progressAnimation, forKey: Config.progressAnimationKey)
        } else {
            gradientLayer.removeAnimation(forKey: Config.progressAnimationKey)
        }
    }
}
