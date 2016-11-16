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
    let imageView: UIImageView
    var delegate: MessagesViewController?

    lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar(frame: CGRect.zero).withAutoLayout()
        navBar.barTintColor = .white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                      NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)]

        let navigationItem = UINavigationItem(title: "Personalize your postcard")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
        navBar.items = [navigationItem]

        return navBar
    }()

    init(locationName: String) {
        imageName = locationName
        imageView = UIImageView(image: UIImage(named: imageName)!).withAutoLayout()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(navBar)
        view.addSubview(imageView)

        setupConstraints()
    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(navBar.widthAnchor.constraint(equalToConstant: view.bounds.size.width))
        constraints.append(navBar.heightAnchor.constraint(equalToConstant: 44.0))
        constraints.append(navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 90))

        constraints += imageView.constraintsToFillSuperviewHorizontally()
        constraints.append(imageView.heightAnchor.constraint(equalToConstant: 150.0))
        constraints.append(imageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 8.0))

        NSLayoutConstraint.activate(constraints)
    }

    /// Call to dismiss this modal view controller and send the resulting postcard out
    func doneEditing() {
        let postcard = Postcard(message: "Should we go?",
                                destination: Destination(name: imageName),
                                bookDate: "today",
                                imageName: imageName)
        delegate?.postCardConfigurationViewDidEndEditing(postcard: postcard, controller: self)
    }
}
