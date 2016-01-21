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

enum SingUp {
    
    case Email(PFUser)
    case Facebook
    case None
    
    func singUp(delegate: SingUpDelegate){
        
        switch self {
        case let .Email(user)  :
            singUpUsingParse(delegate, signUpWithEmail: user)
            
            
        case .Facebook:
            break
            
        case .None:
            break
            
        }
        
    }
    
    private func singUpUsingParse(delegate: SingUpDelegate, signUpWithEmail user: PFUser){
        
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            guard error == nil else{
                let  errorString = error!.userInfo["error"] as? NSString
                delegate.singUp(nil, didFaild: errorString!)
                return
            }
            
            if succeeded {
                delegate.singUp(nil, didSingUp: user)
            }else{
                delegate.singUp(nil, didFaild: "")
            }
        }
    }
    
    
    
    
    
}


