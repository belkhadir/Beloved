//
//  User.swift
//  Beloved
//
//  Created by Anas Belkhadir on 07/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import Foundation


struct User{
    
    //Base Authentication
    var email:String? = nil
    var password:String? = nil
    
    //Base SingUp
    var firstName: String? = nil
    var lastName: String? = nil
    var userName: String? = nil
    var image64EncodeImage: String? = nil
    var date: String? = nil
    
    init(email:String?, password: String?) {
        self.email = email!
        self.password = password!
    }
    
    init(){
        
    }
    
    init(parameter: [String: AnyObject]){
        
        userName = parameter[FirebaseHelper.JSONKEY.USERNAME] as? String
        lastName = parameter[FirebaseHelper.JSONKEY.LAST_NAME] as? String
        firstName = parameter[FirebaseHelper.JSONKEY.FIRST_NAME] as? String
        email = parameter[FirebaseHelper.JSONKEY.EMAIL] as? String
        image64EncodeImage = parameter[FirebaseHelper.JSONKEY.IMAGE] as? String
        password = parameter[FirebaseHelper.JSONKEY.PASSWORD] as? String
        date = parameter[FirebaseHelper.JSONKEY.DATE] as? String
        
    }
    
    init(email:String?, password: String?, firstName: String?,
        lastName: String?, userName: String?){
        self.email = email!
        self.password = password!
        self.firstName = firstName!
        self.lastName = lastName!
        self.userName = userName
    }
    
}