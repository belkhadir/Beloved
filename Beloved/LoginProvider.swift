//
//  LoginProvider.swift
//  Beloved
//
//  Created by Anas Belkhadir on 17/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol LoginProviderDelegate {
    func loginProvider(navigation: UIViewController?, didSuccessed user: User)
    func loginProvider(navigation: UIViewController?, didFaild error: NSString)
}


enum LoginProvider {

    case Email(User)
    case Facebook
    case None

    func login(delegate: LoginProviderDelegate){
        
        switch self {
        case let .Email(user)  :
            login(delegate, login: user)
        
        case .Facebook:
            break
            
        case .None:
            break
        
        }
        
    }
    
   private func loginWithFacebook(delegate: LoginProviderDelegate){
        
    
    }

   private func login(delegate: LoginProviderDelegate, login user: User){
            let ref = Firebase(url: "https://beloved.firebaseio.com")
    ref.authUser(user.email, password: user.password, withCompletionBlock: {
            (error, auth) in
            guard error == nil else {

                delegate.loginProvider(nil, didFaild: error.description as NSString)
                return
            }
            NSUserDefaults.standardUserDefaults().setValue(auth.uid, forKey: "uid")
            delegate.loginProvider(nil, didSuccessed: user)
        
        
        
        
    })
    
    }
        
        
    
    
}







