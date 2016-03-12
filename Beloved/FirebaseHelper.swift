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

    typealias completionHandlerMessage = (error: String? , messages: [String: AnyObject]?) -> Void
    typealias completionHandlerResult = (result: AnyObject?, userKeyId: String?) -> Void
    typealias completionHandlerSuccess = (success: Bool) -> Void
    static let BASEREF = Firebase(url: Constants.BASE_URL)

    
    let ref = Firebase(url: "https://beloved.firebaseio.com")
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
        completionHandler: (error: String?, messageId: String?) -> Void ) {

        let messageAutoId = messageRef.childByAutoId().key
        let id =   from < to ? from + to : to + from
        
        let newMessage = [
            JSONKEY.SENDERID    : from,
            JSONKEY.MESSAGE : message,
            JSONKEY.DATE : "\(NSDate())" ,
          
        ]
        
        messageRef?.childByAppendingPath("\(id)/\(messageAutoId)").setValue(newMessage, withCompletionBlock: {
            (error, firebase) in
            if error == nil {
                completionHandler(error: nil, messageId: messageAutoId)
            }else{
                completionHandler(error: error.description, messageId: nil)
            }
        })
    
    }
    
    
    
    
    
    func retrieveMessage(from: String, to: String , completionHandler: completionHandlerMessage){
        
        messageRef.childByAppendingPath(id(from, to)).observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let messageKey = snapshot.key as String
            self.messageRef.childByAppendingPath("\(self.id(from, to))/\(messageKey)").observeSingleEventOfType(.Value,
                    withBlock: { snapchot in
                        if let message = snapchot.value as? [String: AnyObject] {
                            
                            completionHandler(error: nil, messages: message)
                        }
                        
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
                completionHandler(result: snapchot.value, userKeyId: userKey)
            })
        })
    }
    
    
    func searchByUserName(userName: String, didExist completionHandler: (exist: Bool) -> Void){

       fetcheAllUser({
            (result, _) in
            if let result = result as? [String: AnyObject] {
                if let newResult = result[FirebaseHelper.JSONKEY.USERNAME] as? String
                    where newResult == userName {
                        completionHandler(exist: true)
                        self.userRef.removeAllObservers()
                }else{
                    completionHandler(exist: false)
                }
            }
        })
    }
    
    func searchByUserName(userName: String, didPickUser completionHandler: (exist: Bool, user: [String: AnyObject]?) -> Void){
        fetcheAllUser({
            (result, userKey) in
            if var result = result as? [String: AnyObject] {
                if let newResult = result[FirebaseHelper.JSONKEY.USERNAME] as? String
                    where newResult == userName {
                        result[FirebaseHelper.JSONKEY.UID] = userKey
                        completionHandler(exist: true, user: result)
                }else{
                    completionHandler(exist: false, user: nil)
                }
            }else{
                completionHandler(exist: false, user: nil)
            }
        })
        
    }
    
    func getSingleUser(userIdKey: String, completionHandler: (error: String?,user: User?)->Void ) {
        
        userRef.childByAppendingPath("\(userIdKey)").observeSingleEventOfType(.Value, withBlock: {
            snapchot in
            if let snapchot = snapchot.value as? [String: AnyObject] {
                completionHandler(error: nil, user: User(parameter: snapchot))
            }else{
                completionHandler(error: "faild to get user Info", user: nil)
            }
        })
        
    }
    
    func retrieveImage(userId: String, didPickImage completionHndler: (imageBaseString: String?) -> Void){
        userRef.childByAppendingPath("\(userId)").observeEventType(.Value, withBlock: {
            completionHndler(imageBaseString: $0.value as? String)
        })
        
    }
    
    
    //Mark let's us to Synchronization data with Firebase
    func observeMessages(from: String, to: String, completionHandler: (dictionary: [String: AnyObject])-> Void) {
        
        //id is the chanel where the conversation between two user are saved
         let id =   from < to ? from + to : to + from
        messageRef.childByAppendingPath(id)
        
        
        // limiting the quesry
        let messagesQuery = messageRef.queryLimitedToLast(25)
        
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FDataSnapshot!) in
            
            //creat dictionary to make it easy to save message
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                for (key, value) in dictionary {
                    
                    
                    let timeinterval : NSTimeInterval = (value[JSONKEY.DATE] as! NSString).doubleValue // convert it in to NSTimeInteral
                    
                    let dateFromServer = NSDate(timeIntervalSince1970:timeinterval)
                    
                    
                    let messageDictionary: [String: AnyObject] = [
                        JSONKEY.SENDERID: value[JSONKEY.SENDERID] as! String,
                        JSONKEY.MESSAGE: value[JSONKEY.MESSAGE] as! String,
                        JSONKEY.DATE: dateFromServer,
                        JSONKEY.MESSAGEID: key
                    ]
                    completionHandler(dictionary: messageDictionary)
                }
            }
        }
    }
    
    
    
    

    class func sharedInstance() -> FirebaseHelper {
        struct Singleton {
            static var sharedInstance = FirebaseHelper()
        }
        return Singleton.sharedInstance
    }
    
}

