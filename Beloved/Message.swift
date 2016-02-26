//
//  Message.swift
//  Beloved
//
//  Created by Anas Belkhadir on 18/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation

enum SenderMessage {
    
    case outGoing
    case inComing
    
}

class Message {
    
    //adding CoreData later
    
    let messageText: String?
    let date: NSDate
    
    let senderMessage: SenderMessage
    
    init(messageText: String?, date: NSDate?, senderMessage: SenderMessage = .outGoing ){
        
        self.messageText = messageText
        self.date = date!
        self.senderMessage = senderMessage
    }
    
    
    //TODO: make The Message support image
    
}