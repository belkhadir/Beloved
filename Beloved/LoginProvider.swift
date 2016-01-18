//
//  LoginProvider.swift
//  Beloved
//
//  Created by Anas Belkhadir on 17/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import Parse



enum LoginProvider {

    case Email(PFUser)
    case Facebook
    case None

    func login(delegate: LoginProviderDelegate){
        
        switch self {
        case let .Email(user)  :
            login(delegate, loginWithUsername: user)
        
        case .Facebook:
            break
            
        case .None:
            break
        
        }
        
    }
    
    func loginWithFacebook(delegate: LoginProviderDelegate){
        
    
    }
    
    func login(delegate: LoginProviderDelegate, loginWithUsername user: PFUser){
        
        PFUser.logInWithUsernameInBackground(user.username!, password: user.password!){
            (user: PFUser?, error: NSError?) -> Void in
            
            guard error == nil else{
                delegate.loginProvider(nil, didFaild: (error!.userInfo["error"] as? NSString)!)
                return
            }
            
            if user != nil {
                delegate.loginProvider(nil, didSuccessed: user!)
            }else{
                delegate.loginProvider(nil, didFaild: "Error Occur please contact the admin")
            }
            
        }
        
        
    }
    
}







