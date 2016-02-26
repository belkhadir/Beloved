//
//  FirebaseHelper.swift
//  Beloved
//
//  Created by Anas Belkhadir on 31/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import Firebase



class FirebaseHelper {

    typealias completionHandlerMessage = (error: String? , messages: AnyObject?) -> Void
    typealias completionHandlerResult = (result: AnyObject?) -> Void
    typealias completionHandlerSuccess = (success: Bool) -> Void
    static let BASEREF = Firebase(url: Constants.BASE_URL)

    let messageRef  = Firebase(url: Constants.MESSAGE_URL)
    let userRef = Firebase(url: Constants.USER_URL)
    
    
    let id = {(from:String , to: String) -> String in
            return from < to ? from + to : to + from
    }
    
    var currentUserRef : Firebase? {
        
        if let userId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
            return  Firebase(url: Constants.USER_URL).childByAppendingPath(userId)
        }
        return nil
    
    }
    
    
    func creatNewAccount(uid: String, user: Dictionary<String, AnyObject>,
        completionHandler: (error:NSError?, succeed: Bool)-> Void ){
        
        let ref = Firebase(url: Constants.USER_URL)
        ref.childByAppendingPath(uid).setValue(user, withCompletionBlock: {
            (error, ref) in
                if error != nil  {
                    completionHandler(error: error, succeed: false)
                }else{
                    completionHandler(error: nil, succeed: true)
                }
            })

    }
    
    
    func sendMessage(from: String, to: String, message: String,
        completionHandler: (error: String?, firebase: Firebase!) -> Void ) {

        let messageAutoId = messageRef.childByAutoId().key
        let id =   from < to ? from + to : to + from
        
        let newMessage = [
            "from" : from,
            "to"    : to,
            "message" : message,
            "date" : "\(NSDate())"
        ]
        
        messageRef?.childByAppendingPath("\(id)/\(messageAutoId)").setValue(newMessage, withCompletionBlock: {
            (error, firebase) in
            if error == nil {
                completionHandler(error: nil, firebase: firebase)
            }else{
                completionHandler(error: error.description, firebase: firebase)
            }
        })
    
    }
    
    
    
    
    
    func retrieveMessage(from: String, to: String , completionHandler: completionHandlerMessage){
        
        messageRef.childByAppendingPath(id(from, to)).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let messageKey = snapshot.key as String
            self.messageRef.childByAppendingPath("\(self.id(from, to))/\(messageKey)").observeSingleEventOfType(.Value,
                    withBlock: { snapchot in
                                completionHandler(error: nil, messages: snapchot.value)
            })
        })
        
        
    }
    
    func searchByFullName(toFind: String, completionHandler: completionHandlerResult){
        
        userRef.observeEventType(.ChildAdded, withBlock: {
            snapchot in
            let userKey = snapchot.key as String
            self.userRef.childByAppendingPath("\(userKey)").observeSingleEventOfType(.Value, withBlock: {
                snapchot in
                
            })
            
        })
        
    }
    
    func fetcheAllUser(completionHandler: completionHandlerResult ) {
        userRef.observeEventType(.ChildAdded, withBlock: {
            snapchot in
            let userKey = snapchot.key
            self.userRef.childByAppendingPath("\(userKey)").observeSingleEventOfType(.Value, withBlock: {
                snapchot in
                    completionHandler(result: snapchot.value)
            })
        })
    }
    
    
    func searchByUserName(userName: String, didExist completionHandler: (exist: Bool) -> Void){
        
        FirebaseHelper.sharedInstance().fetcheAllUser({
            result in
            if let result = result as? [String: AnyObject] {
                if let newResult = result[FirebaseHelper.JSONKEY.USERNAME] as? String
                    where newResult == userName {
                        completionHandler(exist: true)
                    
                }else{
                    completionHandler(exist: false)
                }
            }else{
                completionHandler(exist: false)
            }
        })
    }
    
    func searchByUserName(userName: String, didPickUser completionHandler: (exist: Bool, user: User?) -> Void){
        
        FirebaseHelper.sharedInstance().fetcheAllUser({
            result in
            if let result = result as? [String: AnyObject] {
                if let newResult = result[FirebaseHelper.JSONKEY.USERNAME] as? String
                    where newResult == userName {
                        completionHandler(exist: true, user: User(parameter: result))
                }else{
                    completionHandler(exist: false, user: nil)
                }
            }else{
                completionHandler(exist: false, user: nil)
            }
        })
    }
    
    func retrieveImage(userId: String, didPickImage completionHndler: (imageBaseString: String?) -> Void){
        userRef.childByAppendingPath("\(userId)").observeEventType(.Value, withBlock: {
            completionHndler(imageBaseString: $0.value as? String)
        })
        
    }
    
    
    
    
    
    
    func updateFirstName(completionHandle: completionHandlerSuccess){
        
        
        
    }
    
    
    
    
    

    class func sharedInstance() -> FirebaseHelper {
        struct Singleton {
            static var sharedInstance = FirebaseHelper()
        }
        return Singleton.sharedInstance
    }
    
}
