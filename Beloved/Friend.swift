//
//  Friend.swift
//  Beloved
//
//  Created by Anas Belkhadir on 18/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import CoreData

class Friend: NSManagedObject{
    
    struct Keys {
        static let username = "username"
        static let PosterPath = "poster_path"
        static let uid = "uid"
    }
    
    @NSManaged var username: String?
    @NSManaged var posterPath: String?
    @NSManaged var uid: String?
    
    @NSManaged var currentUser: CurrentUserConnected?
    @NSManaged var messages: [Message]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(parameter: [String: AnyObject], context: NSManagedObjectContext)   {
        let entity =  NSEntityDescription.entityForName("Friend", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        username = parameter[Keys.username] as? String
        posterPath = parameter[Keys.PosterPath] as? String
        uid = parameter[Keys.uid] as? String
    }
    
//    
//    var posterImage: UIImage? {
//        
//        get {
//            return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
//        }
//        
//        set {
//            TheMovieDB.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
//        }
//    }
    
    
    
}