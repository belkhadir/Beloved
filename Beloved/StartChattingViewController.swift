//
//  ListOfMessageViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 21/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import CoreData


class StartChattingViewController: JSQMessagesViewController {
    
    var friend: Friend?
    var jGSMessages = [JSQMessage]()
    var messages: [Message] = [Message]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        senderDisplayName = ""
        title = ""
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        setupBubbles()
        
        messages = fetchedAllMessage() as [Message] //ISSUE come from this line and affect the comming line
        //The app crashes when we post a message to a user, moving back and then trying to post another message
        if messages.count > 0 {
            for message in messages {
                let jGSMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: message.date, text: message.messageText)
                jGSMessages.append(jGSMessage)
            }
        }
    }
    


    func fetchedAllMessage()  -> [Message] {
        
        //creat the fetch request
        let fetchedRequest = NSFetchRequest(entityName: "Message")
        let predicate = NSPredicate(format: "friend = %@", friend!)
        fetchedRequest.predicate = predicate
        
        //execute the fetch request
        do {
            return try sharedContext.executeFetchRequest(fetchedRequest) as! [Message]
        }catch _ {
            return [Message]()
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jGSMessages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = jGSMessages[indexPath.item] // 1
            if message.senderId == senderId { // 2
                return outgoingBubbleImageView
            } else { // 3
                return incomingBubbleImageView
            }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
            return nil
    }
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                as! JSQMessagesCollectionViewCell
            
            let message = jGSMessages[indexPath.item]
            
            if message.senderId == senderId {
                
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.blackColor()
            }
            
            return cell
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return jGSMessages[indexPath.item]
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = jGSMessages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = jGSMessages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
        senderDisplayName: String!, date: NSDate!) {
            let dictionary = [
                FirebaseHelper.JSONKEY.MESSAGE: text!,
                FirebaseHelper.JSONKEY.SENDERID: senderId!,
                FirebaseHelper.JSONKEY.DATE: date!
            ]
            FirebaseHelper.sharedInstance().sendMessage(senderId!, to: friend!.username!, message: text!, completionHandler: {
                (error, _) in
                if error == nil {
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                    let message = Message(parameter: dictionary, context: self.sharedContext)
                    message.friend = self.friend
                    do {
                        try self.sharedContext.save()
                    }catch _ {}
                    
                    self.jGSMessages.append(JSQMessage(senderId: senderId!, displayName: self.friend!.username!, text: text))
                    self.finishSendingMessage()
                }else{
                    self.showAlert(.custom("Send Message Faild",error!))
                }
            })
    }
}