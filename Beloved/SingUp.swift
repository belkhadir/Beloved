//
//  SingUp.swift
//  Beloved
//
//  Created by Anas Belkhadir on 17/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation
import UIKit
import Parse

protocol SingUpDelegate{
    
    func singUp(navigation: UIViewController?, didSingUp user: PFUser)
    func singUp(navigation: UIViewController?, didFaild error: NSString)

}



class SingUp {
    
    
    
    var user = PFUser()
    

    
    init(user: PFUser){
        self.user.username = user.username
        self.user.email = user.email
        self.user.password = user.password
    }
    
    
    
    func singUpUsingParse(delegate: SingUpDelegate){
    
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            guard error == nil else{
                let  errorString = error!.userInfo["error"] as? NSString
                delegate.singUp(nil, didFaild: errorString!)
                return
            }
            
            if succeeded {
                delegate.singUp(nil, didSingUp: self.user)
            }else{
                delegate.singUp(nil, didFaild: "")
            }
        }
    }
    
    
    func singUpUsingFacebook() {
        
    }
    
    
    
    
    
}