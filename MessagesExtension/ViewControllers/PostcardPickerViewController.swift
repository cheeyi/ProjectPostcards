//
//  PostcardPickerViewController.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import Messages
import UIKit

class PostcardPickerViewController: UICollectionViewController {

    /// The MSMessagesAppViewController responsible for interacting with the Messages application
    lazy var messageParentViewController: MessagesViewController = {
        return self.parent as! MessagesViewController
    }()
    let reuseIdentifier = "PostcardCollectionViewCell"
    let viewModel = PostcardPickerViewModel()

    override func viewDidLoad() {
        view.backgroundColor = .white
        configureCollectionView()
    }

    private func configureCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(PostcardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func postCardConfigurationViewDidEndEditing(postcard: UIImage, imageTitle: String, caption: String) {
        dismiss(animated: true) { [unowned self] in
            self.composeMessage(postcard: postcard, imageTitle: imageTitle, caption: caption) // TODO: Pass in what the user did in PostcardConfigurationViewController
        }
    }

    /// Tells the main MessagesViewController to transition into compact mode and prepares the message to be sent
    fileprivate func composeMessage(postcard: UIImage, imageTitle: String, caption: String) {
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage(named: viewModel.imageNames.first!) // TODO: Use postcard
        layout.imageTitle = "Totally a test" // TODO: Use imageTitle
        layout.caption = "Hello world!" // TODO: Use caption

        let message = MSMessage()
        message.layout = layout
        messageParentViewController.sendPostcard(message: message)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension PostcardPickerViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostcardCollectionViewCell
        cell.destination = Destination(name: viewModel.imageNames[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postcardConfigVC = PostcardConfigurationViewController(locationName: viewModel.imageNames[indexPath.row])
        postcardConfigVC.delegate = self
        messageParentViewController.requestPresentationStyle(.expanded)
        present(postcardConfigVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewFlowLayoutDelegate

extension PostcardPickerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = 8 * (itemsPerRow + 2)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
