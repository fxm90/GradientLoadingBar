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

    open override var isHidden: Bool {
        didSet {
            viewModel.isHidden = isHidden
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

    /// Colors used for the gradient.
    public var gradientColors: [UIColor] {
        get {
            return viewModel.gradientColors
        }
        set {
            viewModel.gradientColors = newValue
        }
    }

    // MARK: - Private properties

    /// Layer holding the gradient.
    private var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()

        layer.anchorPoint = .zero
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1.0, y: 0.0)

        return layer
    }()

    ///
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

        // Unfortunately `CALayer` is not affected by autolayout, so any change in the size of the view will not change the gradient layer.
        // That's why we'll have to update the frame here manually.

        // Three times of the width in order to apply normal, reversed and normal gradient to simulate infinte animation
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
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

        bindViewModelToView()
    }

    private func bindViewModelToView() {
        viewModel.gradientLayerColors.subscribeDistinct { [weak self] newGradientLayerColors, _ in
            self?.gradientLayer.colors = newGradientLayerColors
        }.disposed(by: &disposeBag)

        viewModel.animationState.subscribeDistinct { [weak self] newAnimationState, _ in
            switch newAnimationState {
            case .none:
                self?.stopProgressAnimation()

            case let .animating(duration):
                self?.startProgressAnimation(duration: duration)
            }
        }.disposed(by: &disposeBag)
    }

    private func startProgressAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "position")

        animation.fromValue = CGPoint(x: -2 * bounds.size.width, y: 0)
        animation.toValue = CGPoint.zero
        animation.isRemovedOnCompletion = false
        animation.repeatCount = Float.infinity
        animation.duration = duration

        gradientLayer.add(animation, forKey: GradientActivityIndicatorView.progressAnimationKey)
    }

    private func stopProgressAnimation() {
        gradientLayer.removeAnimation(forKey: GradientActivityIndicatorView.progressAnimationKey)
    }
}
