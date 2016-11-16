//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import UIKit
import Messages
import Alamofire
import jot

@objc(MessagesViewController) // Workaround so we can do this without storyboards

class MessagesViewController: MSMessagesAppViewController {

    fileprivate var selectedImageName: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - View set up

    fileprivate func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        // Determine the controller to present.
        let controller: UIViewController
        if presentationStyle == .compact {
            // Show a list of Post cards
            controller = instantiatePostcardViewController()
        }
        else {
            if let message = conversation.selectedMessage {
                controller = instantiateRecipientViewController(forMessage: message)
            } else {
                if let imageName = selectedImageName {
                    requestPresentationStyle(.expanded)
                    let postcardConfigVC = PostcardConfigurationViewController(locationName: imageName)
                    postcardConfigVC.delegate = self
                    controller = postcardConfigVC
                    selectedImageName = nil
                } else {
                    controller = instantiatePostcardViewController()

                }
            }
        }

        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }

        // Embed the new controller.
        addChildViewController(controller)

        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)

        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        controller.didMove(toParentViewController: self)
    }

    private func instantiatePostcardViewController() -> UIViewController {
        print("🏙 instantiate Postcard ViewController")
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 320.0, height: 44.0)
        let postcardsVC = PostcardPickerViewController(collectionViewLayout: layout)
        postcardsVC.delegate = self
        return postcardsVC
    }

    private func instantiateRecipientViewController(forMessage selectedMessage: MSMessage) -> UIViewController {
        print("👨🏼 instantiate Recipient ViewController")
        guard let postcard = Postcard(message: selectedMessage) else {
            fatalError()
        }
        return PostcardRecipientViewController(postcard: postcard)//Image: UIImage(), locationName: (payload?[0].value!)!)
    }

    // MARK: - Conversation Handling

    func sendPostcard(message: MSMessage) {
        activeConversation?.insert(message, completionHandler: nil)
        requestPresentationStyle(.compact)
        presentViewController(for: activeConversation!, with: .compact)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        presentViewController(for: conversation, with: .expanded)
    }

    override func didBecomeActive(with conversation: MSConversation) {
        // Decides which child view controller to display depending on if user ended up in the extension by selecting a message
    }

    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        presentViewController(for: conversation, with: .expanded)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .compact {
            guard let conversation = activeConversation else { fatalError() }
            presentViewController(for: conversation, with: .compact)
        }
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
}

extension MessagesViewController: PostcardPickerViewControllerDelegate {
    func postcardsViewControllerDidSelectAdd(_ selectedItemName: String, controller: PostcardPickerViewController) {
        print("👁 postcard \(selectedItemName) selected")
        selectedImageName = selectedItemName
        guard let conversation = activeConversation else { fatalError() }
        presentViewController(for: conversation, with: .expanded)
    }
}

extension MessagesViewController {
    func postCardConfigurationViewDidEndEditing(postcard: Postcard, controller: UIViewController) {
        composeMessage(postcard: postcard)
//        controller.dismiss(animated: true, completion: nil)
    }

    fileprivate func composeMessage(postcard: Postcard) {
        let layout = MSMessageTemplateLayout()
        layout.image = UIImage(named: postcard.imageName)
        layout.imageTitle = postcard.message
        layout.imageSubtitle = postcard.destinationName()
        layout.caption = "When should we go? How about \(postcard.bookDate)"

        // pass custom data to the app on the recipient's side
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: Postcard.messageKey, value: postcard.message),
            URLQueryItem(name: Postcard.destinationKey, value: postcard.destination.name),
            URLQueryItem(name: Postcard.bookDateKey, value: postcard.bookDate),
            URLQueryItem(name: Postcard.imageKey, value: postcard.imageName),
        ]

        let message = MSMessage()
        message.layout = layout
        message.url = components.url
        sendPostcard(message: message)
    }
}
