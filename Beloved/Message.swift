//
//  Message.swift
//  Beloved
//
//  Created by Anas Belkhadir on 18/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import CoreData

class Message: NSManagedObject{
    
    
    @NSManaged var messageId: String
    @NSManaged var messageText: String
    @NSManaged var date: NSDate
    @NSManaged var senderId: String
    
    @NSManaged var friend: Friend?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(parameter: [String: AnyObject], context: NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("Message", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        messageText = parameter[FirebaseHelper.JSONKEY.MESSAGE] as! String
        date = parameter[FirebaseHelper.JSONKEY.DATE] as! NSDate
        senderId = parameter[FirebaseHelper.JSONKEY.SENDERID] as! String
        messageId = parameter[FirebaseHelper.JSONKEY.MESSAGE] as! String
    }
    
}