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
        view.backgroundColor = .white
    }

    /// Call to dismiss this modal view controller and send the resulting postcard out
    func doneEditing() {
        let postcard = UIImage(named: "asd")
        let imageTitle = ""
        let caption = ""
        delegate?.postCardConfigurationViewDidEndEditing(postcard: postcard!, imageTitle: imageTitle, caption: caption)
    }
}
