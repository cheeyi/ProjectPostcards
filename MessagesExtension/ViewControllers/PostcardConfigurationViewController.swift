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

    let locationName: String
    var delegate: PostcardPickerViewController?

    init(locationName: String) {
        self.locationName = locationName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBar()
        view.backgroundColor = .white
    }

    private func addNavigationBar() {
        let navBar = UINavigationBar(frame: CGRect.zero).withAutoLayout()
        navBar.barTintColor = .white
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black,
                                      NSFontAttributeName: UIFont.systemFont(ofSize: 16.0, weight: UIFontWeightMedium)]
        view.addSubview(navBar)

        let constraints = [
            navBar.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 44.0),
            navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 86.0)
        ]
        NSLayoutConstraint.activate(constraints)

        let navigationItem = UINavigationItem(title: "Personalize your postcard")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEditing))
        navBar.items = [navigationItem]
    }

    /// Call to dismiss this modal view controller and send the resulting postcard out
    func doneEditing() {
        let postcard = UIImage(named: "SFO - San Francisco")
        let imageTitle = ""
        let caption = ""
        delegate?.postCardConfigurationViewDidEndEditing(postcard: postcard!, imageTitle: imageTitle, caption: caption)
    }
}
