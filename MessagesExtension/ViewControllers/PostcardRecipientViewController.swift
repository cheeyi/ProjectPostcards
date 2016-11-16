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

    init(postcard: Postcard) {
        self.postcard = postcard
        guard let image = UIImage(named: postcard.imageName) else {
            fatalError("image not found")
        }
        postcardImageView = UIImageView(image: image)
        messageLabel.text = postcard.message
        destinationLabel.text = postcard.destination.name
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
        let dateString = todaysDate()
        let imageName = postcard.imageName
        let indexForAirportCode = imageName.index(imageName.startIndex, offsetBy: 3)
        let airportCode = postcard.imageName.substring(to: indexForAirportCode)
        let constructedDeeplinkURL = URL(string: "expda://flightSearch?origin=MSP&destination=\(airportCode)&departureDate=\(dateString)&numAdults=2")!
        UIApplication.shared.open(constructedDeeplinkURL,
                                  options: [String: Any](),
                                  completionHandler: nil)
    }

    private func setupLabels() {
        messageLabel.font = UIFont(name: "DEFTONE", size: 24.0)
        messageLabel.textColor = .white
        destinationLabel.font = UIFont(name: "Airstream", size: 36.0)
        destinationLabel.textColor = .white
    }

    private func setupButton() {
        bookButton.setTitle("Book Now", for: .normal)
        bookButton.setTitleColor(.white, for: .normal)
        bookButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightSemibold)
        bookButton.backgroundColor = UIColor(hexString: "1A6EFF")
        bookButton.addTarget(self, action: #selector(PostcardRecipientViewController.deeplinkToExpediaBookings), for: .touchUpInside)
    }

    private func setupViews() {
        postcardImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postcardImageView)
        view.addSubview(messageLabel)
        view.addSubview(destinationLabel)
        view.addSubview(bookButton)
    }

    private func setupConstraints() {
        let margin: CGFloat = 20.0

        var constraints: [NSLayoutConstraint] = []
        constraints.append(postcardImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        constraints.append(postcardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(postcardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(postcardImageView.heightAnchor.constraint(equalToConstant: 300.0))
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

        NSLayoutConstraint.activate(constraints)
    }

    private func todaysDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}
