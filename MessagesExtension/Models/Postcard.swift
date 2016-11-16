//
//  Postcard.swift
//  ProjectPostcards
//
//  Created by Chee Yi Ong on 11/15/16.
//  Copyright © 2016 Team ProjectPostcards. All rights reserved.
//

import Foundation
import Messages

struct Postcard {
    static let messageKey = "Message"
    static let destinationKey = "Destination"
    static let bookDateKey = "BookDate"
    static let imageKey = "ImageKey"

    let message: String
    let destination: Destination
    let bookDate: String
    let imageName: String

    init(message: String, destination: Destination, bookDate: String, imageName: String) {
        self.message = message
        self.destination = destination
        self.bookDate = bookDate
        self.imageName = imageName
    }
    
    init?(queryItems: [URLQueryItem]) {
        var queryMessage: String?
        var queryDestination: Destination?
        var queryBookDate: String?
        var queryImageName: String?

        for queryItem in queryItems {
            guard let value = queryItem.value else { continue }

            if queryItem.name == Postcard.messageKey {
                queryMessage = value
            }
            if queryItem.name == Postcard.destinationKey {
                queryDestination = Destination(name: value)
            }
            if queryItem.name == Postcard.bookDateKey {
                queryBookDate = value
            }
            if queryItem.name == Postcard.imageKey {
                queryImageName = value
            }
        }

        message = queryMessage ?? ""
        destination = queryDestination ?? Destination(name: "")
        bookDate = queryBookDate ?? ""
        imageName = queryImageName ?? ""
    }

    func destinationName() -> String {
        let indexForCityName = imageName.index(imageName.startIndex, offsetBy: 6)
        return imageName.substring(from: indexForCityName)
    }
}

extension Postcard {
    init?(message: MSMessage?) {
        guard let messageURL = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: messageURL, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }

        self.init(queryItems: queryItems)
    }
}
