//
//  PostcardConfigurationViewController.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import Messages
import UIKit

// TODO: @bryan
class PostcardConfigurationViewController: UIViewController {

    let imageName: String
    var delegate: MessagesViewController?

    lazy var drawingView: DrawingView = {
        let view = DrawingView(image: UIImage(named: self.imageName))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(navBar)
        view.addSubview(drawingView)

        setupConstraints()
    }

    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints.append(navBar.widthAnchor.constraint(equalToConstant: view.bounds.size.width))
        constraints.append(navBar.heightAnchor.constraint(equalToConstant: 44.0))
        constraints.append(navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 86.0))

        constraints.append(drawingView.topAnchor.constraint(equalTo: navBar.bottomAnchor))
        constraints.append(drawingView.leftAnchor.constraint(equalTo: view.leftAnchor))
        constraints.append(drawingView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(drawingView.rightAnchor.constraint(equalTo: view.rightAnchor))
        
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
