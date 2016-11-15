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
    let headerReuseIdentifier = "headerCell"
    let viewModel = PostcardPickerViewModel()
    var filteredItems: [String] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false

    override func viewDidLoad() {
        view.backgroundColor = .white
        configureCollectionView()
        configureSearchController()
        definesPresentationContext = true
        filteredItems = viewModel.imageNames
        assert(filteredItems.count > 0)
    }

    private func configureCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(PostcardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
    }

    func postCardConfigurationViewDidEndEditing(postcard: UIImage, imageTitle: String, imageSubtitle: String, caption: String) {
        dismiss(animated: true) { [unowned self] in
            self.composeMessage(postcard: postcard, imageTitle: imageTitle, imageSubtitle: imageSubtitle, caption: caption) // TODO: Pass in what the user did in PostcardConfigurationViewController
        }
    }

    /// Tells the main MessagesViewController to transition into compact mode and prepares the message to be sent
    fileprivate func composeMessage(postcard: UIImage, imageTitle: String, imageSubtitle: String, caption: String) {
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage(named: viewModel.imageNames.first!) // TODO: Use postcard
        layout.imageTitle = "I sent you a postcard!" // TODO: Use imageTitle
        layout.imageSubtitle = "SFO - San Francisco" // TODO: Use actual location name
        layout.caption = "Check it out, and maybe visit the place yourself too!" // TODO: Use caption

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
        return filteredItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostcardCollectionViewCell
        cell.destination = Destination(name: filteredItems[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messageParentViewController.requestPresentationStyle(.expanded)
        let postcardConfigVC = PostcardConfigurationViewController(locationName: viewModel.imageNames[indexPath.row])
        postcardConfigVC.delegate = self
        present(postcardConfigVC, animated: true, completion: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        headerView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
        return headerView
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

extension PostcardPickerViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // might not be needed
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // clear results when cancel is tapped
        filteredItems = viewModel.imageNames
    }

    func updateSearchResults(for searchController: UISearchController) {

        if messageParentViewController.presentationStyle == .compact {
            messageParentViewController.requestPresentationStyle(.expanded)
        }

        guard let text = searchController.searchBar.text else { return }

        // if user is deleting chars and count is decremented to zero we need to remove isSearching and reset filter
        let userClearedText = text.characters.count == 0
        let hasFilteredResults = filteredItems.count < viewModel.imageNames.count
        if userClearedText && hasFilteredResults && isSearching {
            filteredItems = viewModel.imageNames
            isSearching = false
            return
        }

        guard text.characters.count > 0 else { return }

        isSearching = true
        print("update search results: \(text)")
        let filteredStrings = viewModel.imageNames.filter { (string) -> Bool in
            string.contains(text)
        }
        filteredItems = filteredStrings
    }
}
