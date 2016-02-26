//
//  SingUp.swift
//  Beloved
//
//  Created by Anas Belkhadir on 17/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//


import UIKit
import Firebase



protocol SingUpDelegate{
    
    func singUp(navigation: UIViewController?, didSingUp user: User)
    func singUp(navigation: UIViewController?, didFaild error: NSString)

}

enum SingUp {
    
    case Email(User)
    case Facebook
    case None
    
    func singUp(delegate: SingUpDelegate){
        
        switch self {
        case let .Email(user)  :
            singUpWithEmail(delegate, signUpWithEmail: user)
            
            
        case .Facebook:
            break
            
        case .None:
            break
            
        }
        
    }
    
    private func singUpWithEmail(delegate: SingUpDelegate, signUpWithEmail user: User) {
        
        FirebaseHelper.BASEREF.createUser(user.email, password: user.password, withCompletionBlock: {
            (error: NSError!) in
            if error != nil  {
                delegate.singUp(nil, didFaild: String(error))
            }else {
                FirebaseHelper.BASEREF.authUser(user.email, password: user.password, withCompletionBlock: {
                    (error, authData) in
                    if error != nil {
                        delegate.singUp(nil, didFaild: error.description as String)
                    }else {
                        
                        FirebaseHelper.sharedInstance().searchByUserName(user.userName!,didExist:   {
                            exist in
                            if exist {
                                delegate.singUp(nil, didFaild: "The specified username address is already in use")
                            }else{
                                let newUser = [
                                    FirebaseHelper.JSONKEY.FIRST_NAME : user.firstName!,
                                    FirebaseHelper.JSONKEY.LAST_NAME : user.lastName!,
                                    FirebaseHelper.JSONKEY.USERNAME: user.userName!,
                                    FirebaseHelper.JSONKEY.IMAGE: ""
                                ]
                                FirebaseHelper.sharedInstance().creatNewAccount(authData.uid, user: newUser, completionHandler: {
                                    (error, succeed) in
                                    if succeed {
                                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: FirebaseHelper.JSONKEY.UID)
                                        delegate.singUp(nil, didSingUp: user)
                                        
                                    }else {
                                        delegate.singUp(nil, didFaild: error!.description as String)
                                    }
                                })
                            }
                        })
                        

                    }
                })
            }
        })
    
    
    }
        
    
    
    
    
    
}


