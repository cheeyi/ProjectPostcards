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
            let destinationName = destination!.name
            destinationImageView.image = UIImage(named: destinationName)
            let indexForCityName = destinationName.index(destinationName.startIndex, offsetBy: 6)
            locationNameLabel.text = destinationName.substring(from: indexForCityName)
            DispatchQueue.main.async { self.addGradient() }
        }
    }

    private let destinationImageView = UIImageView().withAutoLayout()
    private let gradientView = UIView().withAutoLayout()
    private let locationNameLabel = UILabel().withAutoLayout()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupImageView()
        setupLocationLabel()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setupConstraints() {
        contentView.addSubview(destinationImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(locationNameLabel)
        var constraints = destinationImageView.constraintsToFillSuperview()
        constraints += gradientView.constraintsToFillSuperview()
        constraints.append(locationNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0))
        constraints.append(locationNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0))
        NSLayoutConstraint.activate(constraints)
    }

    private func setupImageView() {
        destinationImageView.contentMode = .scaleAspectFill
        destinationImageView.clipsToBounds = true
    }

    private func setupLocationLabel() {
        locationNameLabel.textColor = .white
        locationNameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightSemibold)
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
