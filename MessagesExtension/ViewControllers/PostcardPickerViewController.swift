//
//  PostcardPickerViewController.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import Messages
import UIKit

protocol PostcardPickerViewControllerDelegate: class {
    func postcardsViewControllerDidSelectAdd(_ selectedItemName: String, controller: PostcardPickerViewController)
}

class PostcardPickerViewController: UICollectionViewController {

    let margin: CGFloat = 8.0

    /// The MSMessagesAppViewController responsible for interacting with the Messages application
    lazy var messageParentViewController: MessagesViewController = {
        return self.parent as! MessagesViewController
    }()
    let reuseIdentifier = "PostcardCollectionViewCell"
    let headerReuseIdentifier = "headerCell"
    let viewModel = PostcardPickerViewModel()
    weak var delegate: PostcardPickerViewControllerDelegate?
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
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        flowLayout?.minimumLineSpacing = margin
        flowLayout?.minimumInteritemSpacing = margin
        let w = ((collectionView?.frame.width)! - 3 * margin) / 2.0
        flowLayout?.itemSize = CGSize(width: w, height: w)

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
        let imageName = filteredItems[indexPath.row]
        delegate?.postcardsViewControllerDidSelectAdd(imageName, controller: self)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        headerView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
        return headerView
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
