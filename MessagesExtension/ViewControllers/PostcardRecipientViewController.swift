//
//  PostcardRecipientViewController.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import UIKit

class PostcardRecipientViewController: UIViewController {

    let postcardImage: UIImage
    let locationName: String

    init(postcardImage: UIImage, locationName: String) {
        self.postcardImage = postcardImage
        self.locationName = locationName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
