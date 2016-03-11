//
//  Friendship.swift
//  Beloved
//
//  Created by Anas Belkhadir on 28/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import Firebase


extension FirebaseHelper{
    
    /** Send Request to become friend */
    func canBecomeFirend(userIdKey: String, willAccept status: Bool,willBecomeFriend completionHandler: (error: String? ,success: Bool) -> Void ){
        
        let friendRef = Firebase(url: Constants.USER_URL)
        friendRef.childByAppendingPath("\(CurrentUser.sharedInstance().user!.uid!)/ListOfFriend/").setValue([userIdKey:status], withCompletionBlock: {
            (error, _) in
            if error == nil {
                completionHandler(error: nil, success: true)
            }else{
                completionHandler(error: error.description, success: false)
            }
        })

        friendRef.childByAppendingPath("\(userIdKey)/ListOfFriend/").setValue(["\(CurrentUser.sharedInstance().user!.uid!)" : status], withCompletionBlock: {
            (error, _) in
            if error == nil {
                completionHandler(error: nil, success: true)
            }else{
                completionHandler(error: error.description, success: false)
            }
        })

    }
    
    /** if status is false that's mean the request still pending 
        if it's nil that's mean he refuse the request 
        if it's true that's mean accepte the request */
    func canBecomeFirend(userIdKey: String, didBecomeFriend completionHandler: (status: Bool?) -> Void ){
        let friendRef = Firebase(url: Constants.USER_URL)
        
        let pathString = "\(CurrentUser.sharedInstance().user!.uid!)/ListOfFriend/"
        
        friendRef.childByAppendingPath(pathString).observeSingleEventOfType(.Value, withBlock: {
            snapchot in
            guard let target = snapchot.value as? [String: AnyObject]
            where (target[userIdKey] as? Bool) != nil else{
                completionHandler(status: nil)
                return
            }
            if (target[userIdKey] as! Bool) == true {
                completionHandler(status: true)
            }else{
                completionHandler(status: false)
            }
        })
        
    }
    
    func getAllCurrentUserFirends(completionHandler: (userFriendShip: String?) -> Void) {
        
        FirebaseHelper.sharedInstance().userRef.childByAppendingPath("\(CurrentUser.sharedInstance().user?.uid)/ListOfFriend").observeSingleEventOfType(.Value, withBlock: {
            snapchot in
            
            guard let isFriend = snapchot.value as? Bool else{
                return
            }
            if isFriend {
                completionHandler(userFriendShip: snapchot.key)
            }

        })
    }
}



