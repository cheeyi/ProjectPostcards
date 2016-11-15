//
//  PostcardCollectionViewCell.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import UIKit

class PostcardCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    var destination: Destination? {
        didSet {
            destinationImageView.image = UIImage(named: destination!.name)
            DispatchQueue.main.async { self.addGradient() }
        }
    }

    private let destinationImageView = UIImageView().withAutoLayout()
    private let gradientView = UIView().withAutoLayout()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupImageView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setupConstraints() {
        contentView.addSubview(destinationImageView)
        contentView.addSubview(gradientView)
        var constraints = destinationImageView.constraintsToFillSuperview()
        constraints += gradientView.constraintsToFillSuperview()
        NSLayoutConstraint.activate(constraints)
    }

    private func setupImageView() {
        destinationImageView.contentMode = .scaleAspectFill
        destinationImageView.clipsToBounds = true
    }

    private func addGradient() {
        // A safeguard to ensure we're only doing this once
        guard gradientView.isUserInteractionEnabled && gradientView.frame.height != 0 else { return }
        gradientView.isUserInteractionEnabled = false
        // Add the gradient layer
        let layer = CAGradientLayer()
        let blackGradientColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.frame = gradientView.frame
        layer.colors = [blackGradientColor, UIColor.clear, blackGradientColor]
        gradientView.layer.addSublayer(layer)
    }
}
