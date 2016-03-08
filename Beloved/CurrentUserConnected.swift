//
//  CurrentUser.swift
//  Beloved
//
//  Created by Anas Belkhadir on 08/03/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import CoreData

class CurrentUserConnected: NSManagedObject {
    
    
    struct Keys {
        static let username = "username"
        static let uid = "uid"
    }
    
    
    
    @NSManaged var username: String
    @NSManaged var uid: String
    
    @NSManaged var friend: [Friend]?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
    }
    init(parameter: [String: AnyObject], context: NSManagedObjectContext){
        let entity = NSEntityDescription.entityForName("CurrentUserConnected", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        username = parameter[Keys.username] as! String
        uid = parameter[Keys.uid] as! String
        
    }
    
}