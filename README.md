# ProjectPostcards

## Info
* Nov hackathon project
* Swift 3
* I have Cocoapods modules in the project but I can manage it on my machine so you guys don't have to install Cocoapods or touch Cocoapods in any way. It'll just be like another Swift module that lives in the project.

## What we want to build
* A standalone iMessage extension (app) that allows users to pick from a preselected set of destination images (say 20?) and they're able to personalize it with messages across 3 lines or so, just like a postcard. 
* Recipients can tap into the postcard to view it, and can reply with their own postcard. In that "view the postcard" view, they can then choose to tap on "Book now!" which will deeplink into ExpediaBookings with a flight (or hotel?) search for the destination depicted in the postcard.

## Whiteboarded idea
* Collapsed view (when user first taps into the iMessage app): Scrollable `UICollectionView` grid with popular destinations
* Expanded view: Basically an expanded view of the collapsed view since we'll use the same main `MSMessagesAppViewController`
* Postcard personalization view: Appears when users tap into a destination image. We can show the image in its entirety, with 3 lines on it that users can type their message on (think `UITextView`, or a `UILabel` with a separate UI that lets them type their message and we can update `UILabel.text` after they complete the message). There will be a "Send" or "Done" button on the top right, and the completed postcard will be in the chat box of the Messages app ready to be sent
* Recipient view: Received postcard taking up top half of the screen, bottom half has an optional date picker and a "Book now" button that deeplinks into ExpediaBookings. We will also have a "Reply" button on the top right that can show the expanded view of available destinations so they can pick one and personalize it and reply with their own postcard.

![img](https://i.imgur.com/Qney5y4.jpg)

## References/etc
* Pods installed:
  * AlamoFire
* Example of deeplink: `expda://flightSearch?destination=MSP`
* Example of a destination image from Expedia server: `https://media.expedia.com/mobiata/mobile/apps/ExpediaBooking/TabletDestinations/images/MSP.jpg?downsize=750px:*&crop=w:300/750xw;center,top&output-quality=20&output-format=jpeg` note we can provide a size to be downsized to
* Example of building an iMessage app start-to-finish: https://medium.com/lost-bananas/building-an-interactive-imessage-application-for-ios-10-in-swift-7da4a18bdeed#.tivfslu26 
* WWDC video on iMessage apps: https://developer.apple.com/imessage/ 
* API reference: https://developer.apple.com/reference/messages
