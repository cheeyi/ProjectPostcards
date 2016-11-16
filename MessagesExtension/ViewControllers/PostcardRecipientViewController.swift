//
//  PostcardRecipientViewController.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import UIKit

class PostcardRecipientViewController: UIViewController {

    private let postcard: Postcard

    private let postcardImageView: UIImageView
    private let messageLabel = UILabel()
    private let destinationLabel = UILabel()
    private let bookButton: UIButton
    private let imageBackgroundView = UIView()
    private let stampImageView: UIImageView
    private let postcardDescriptionLabel = UILabel()

    init(postcard: Postcard) {
        self.postcard = postcard
        guard let destinationImage = UIImage(named: postcard.imageName) else {
            fatalError("image not found")
        }
        guard let stampImage = UIImage(named: "air-mail") else { fatalError() }
        postcardImageView = UIImageView(image: destinationImage)
        stampImageView = UIImageView(image: stampImage)
        messageLabel.text = postcard.message
        destinationLabel.text = postcard.destinationName()
        bookButton = UIButton(type: .system)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "E8EAED")
        setupViews()
        setupLabels()
        setupButton()
        setupConstraints()
    }

    func deeplinkToExpediaBookings() {
        // TODO: Assume origin is MSP for demo purposes
        let imageName = postcard.imageName
        let indexForAirportCode = imageName.index(imageName.startIndex, offsetBy: 3)
        let airportCode = postcard.imageName.substring(to: indexForAirportCode)
        let constructedDeeplinkURL = URL(string: "expda://flightSearch?origin=MSP&destination=\(airportCode)&departureDate=\(postcard.bookDate)&numAdults=2")!
        UIApplication.shared.open(constructedDeeplinkURL,
                                  options: [String: Any](),
                                  completionHandler: nil)
    }

    private func setupLabels() {
        messageLabel.font = UIFont(name: "Parisish", size: 36.0)
        messageLabel.textColor = .white
        messageLabel.shadowOffset = CGSize(width: 1, height: 1)
        messageLabel.shadowColor = .black

        destinationLabel.font = UIFont(name: "Airstream", size: 96.0)
        destinationLabel.adjustsFontSizeToFitWidth = true
        destinationLabel.minimumScaleFactor = 0.3
        destinationLabel.textColor = .white
        destinationLabel.shadowOffset = CGSize(width: 1, height: 1)
        destinationLabel.shadowColor = .black

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.date(from: postcard.bookDate)
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let dateString = dateFormatter.string(from: selectedDate ?? Date())
        postcardDescriptionLabel.text = "I'm going to \(postcard.destinationName()) on \(dateString). Let's go together!"
        postcardDescriptionLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        postcardDescriptionLabel.textColor = UIColor(hexString: "0A3D6B")
        postcardDescriptionLabel.numberOfLines = 0
    }

    private func setupButton() {
        bookButton.setTitle("Book with Expedia", for: .normal)
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.titleLabel?.font = UIFont.systemFont(ofSize: 24.0, weight: UIFontWeightThin)
        bookButton.tintColor = .white
        bookButton.backgroundColor = UIColor(hexString: "1A6EFF")
        bookButton.addTarget(self, action: #selector(PostcardRecipientViewController.deeplinkToExpediaBookings), for: .touchUpInside)
        let logoIcon = UIImage(named: "expedia-icon")!
        bookButton.imageEdgeInsets = UIEdgeInsets(top: 8.0, left: 45.0, bottom: 8.0, right: 8.0)
        bookButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -45, bottom: 0, right: -8)
        bookButton.setImage(logoIcon, for: .normal)
        if let buttonImageView = bookButton.imageView {
            buttonImageView.contentMode = .scaleAspectFit
        }

    }

    private func setupViews() {
        postcardImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        stampImageView.translatesAutoresizingMaskIntoConstraints = false
        postcardDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageBackgroundView)
        view.addSubview(postcardImageView)
        view.addSubview(messageLabel)
        view.addSubview(destinationLabel)
        view.addSubview(bookButton)
        view.addSubview(stampImageView)
        view.addSubview(postcardDescriptionLabel)

        stampImageView.alpha = 0.7

        imageBackgroundView.backgroundColor = UIColor(hexString: "faebd7")
        imageBackgroundView.layer.shadowOpacity = 0.5
        imageBackgroundView.layer.shadowRadius = 5
        imageBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageBackgroundView.clipsToBounds = false
    }

    private func setupConstraints() {
        let margin: CGFloat = 15.0
        let borderMargin: CGFloat = 12.0
        var constraints: [NSLayoutConstraint] = []
        constraints.append(imageBackgroundView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        constraints.append(imageBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(imageBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(imageBackgroundView.heightAnchor.constraint(equalToConstant: 300.0))
        constraints.append(postcardImageView.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor, constant: borderMargin))
        constraints.append(postcardImageView.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor, constant: borderMargin))
        constraints.append(postcardImageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor, constant: -borderMargin))
        constraints.append(postcardImageView.bottomAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: -borderMargin))
        constraints.append(messageLabel.leadingAnchor.constraint(equalTo: postcardImageView.leadingAnchor, constant: margin))
        constraints.append(messageLabel.trailingAnchor.constraint(equalTo: postcardImageView.trailingAnchor, constant: -margin))
        constraints.append(messageLabel.bottomAnchor.constraint(equalTo: postcardImageView.bottomAnchor, constant: -margin))
        constraints.append(destinationLabel.topAnchor.constraint(equalTo: postcardImageView.topAnchor, constant: margin))
        constraints.append(destinationLabel.leadingAnchor.constraint(equalTo: postcardImageView.leadingAnchor, constant: margin))
        constraints.append(destinationLabel.trailingAnchor.constraint(equalTo: postcardImageView.trailingAnchor, constant: -margin))
        constraints.append(bookButton.heightAnchor.constraint(equalToConstant: 60.0))
        constraints.append(bookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(bookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(bookButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor))
        constraints.append(stampImageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor))
        constraints.append(stampImageView.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor))
        constraints.append(stampImageView.widthAnchor.constraint(equalTo: stampImageView.heightAnchor))
        constraints.append(stampImageView.widthAnchor.constraint(equalToConstant: 90.0))
        constraints.append(postcardDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin))
        constraints.append(postcardDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin))
        constraints.append(postcardDescriptionLabel.bottomAnchor.constraint(equalTo: bookButton.topAnchor, constant: -30.0))
        NSLayoutConstraint.activate(constraints)
    }
}
