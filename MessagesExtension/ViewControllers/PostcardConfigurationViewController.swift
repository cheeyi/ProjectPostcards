//
//  PostcardConfigurationViewController.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import Messages
import UIKit

class PostcardConfigurationViewController: UIViewController {

    let imageName: String
    var selectedDateString = ""
    var delegate: MessagesViewController?

    // MARK: - Destination image

    let messageTextField = UITextField().withAutoLayout()
    let imageView: UIImageView

    // MARK: - Date

    let dateFormatter = DateFormatter()
    let dateStackView = UIStackView().withAutoLayout()
    let selectDateLabel = UILabel().withAutoLayout()
    let dateTextField = UITextField().withAutoLayout()
    let datePicker = UIDatePicker()

    lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect.zero).withAutoLayout()
        navBar.barTintColor = .white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                      NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightSemibold)]

        let navigationItem = UINavigationItem(title: "Personalize your postcard")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEditing))
        navBar.items = [navigationItem]

        return navBar
    }()

    init(locationName: String) {
        imageName = locationName
        imageView = UIImageView(image: UIImage(named: imageName)!).withAutoLayout()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "E8EAED")

        view.addSubview(navBar)
        view.addSubview(imageView)
        view.addSubview(messageTextField)
        view.addSubview(dateStackView)

        setupDateFieldAndPicker()
        setupImageView()
        setupConstraints()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        messageTextField.font = UIFont(name: "Parisish", size: 36.0)
        messageTextField.textColor = .white
        messageTextField.text = "Greetings"
        messageTextField.layer.shadowColor = UIColor.black.cgColor
        messageTextField.layer.shadowOffset = CGSize(width: 1, height: 1)
    }

    private func setupDateFieldAndPicker() {
        selectDateLabel.text = "Select date"
        dateFormatter.dateFormat = "yyyy-MM-dd"

        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(updateDateField), for: .valueChanged)
        datePicker.date = Date()

        dateTextField.backgroundColor = .white
        dateTextField.inputView = datePicker
        dateTextField.tintColor = .clear
        dateTextField.textAlignment = .center
        dateTextField.layer.cornerRadius = 8.0
        dateTextField.borderStyle = .roundedRect
        dateTextField.layer.borderWidth = 1.0
        dateTextField.layer.borderColor = UIColor.darkGray.cgColor

        dateStackView.distribution = .fillProportionally
        dateStackView.alignment = .fill
        dateStackView.axis = .horizontal
        dateStackView.spacing = 10.0
        dateStackView.addArrangedSubview(selectDateLabel)
        dateStackView.addArrangedSubview(dateTextField)
    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(navBar.widthAnchor.constraint(equalToConstant: view.bounds.size.width))
        constraints.append(navBar.heightAnchor.constraint(equalToConstant: 44.0))
        constraints.append(navBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))

        constraints += imageView.constraintsToFillSuperviewHorizontally()
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 200.0))
        constraints.append(imageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 0.0))

        constraints.append(messageTextField.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16.0))
        constraints.append(messageTextField.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16.0))
        constraints.append(messageTextField.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.0))

        constraints.append(dateTextField.widthAnchor.constraint(equalToConstant: 150.0))
        constraints.append(dateStackView.widthAnchor.constraint(equalToConstant: 275.0))
        constraints.append(dateStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0))
        constraints.append(dateStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0))
        constraints.append(dateStackView.heightAnchor.constraint(equalToConstant: 25.0))

        NSLayoutConstraint.activate(constraints)
    }

    func updateDateField() {
        let selectedDate = dateFormatter.string(from: datePicker.date)
        selectedDateString = selectedDate
        dateTextField.text = selectedDate
    }

    /// Call to dismiss this modal view controller and send the resulting postcard out
    func doneEditing() {
        let postcard = Postcard(message: messageTextField.text!,
                                destination: Destination(name: imageName),
                                bookDate: selectedDateString,
                                imageName: imageName)
        delegate?.postCardConfigurationViewDidEndEditing(postcard: postcard, controller: self)
    }

    func cancelEditing() {
        delegate?.postCardConfigurationViewDidCancelEditing()
    }
}
