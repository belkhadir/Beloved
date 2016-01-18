//
//  ViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 17/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import Parse

protocol LoginProviderDelegate {
    func loginProvider(navigation: UIViewController?, didSuccessed user: PFUser)
    func loginProvider(navigation: UIViewController?, didFaild error: NSString)
}


class ViewController: UIViewController, LoginProviderDelegate, SingUpDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func login(sender: UIButton) {
        
        let user = PFUser()
        user.password = "123456789"
        user.username = "A"
        let login = LoginProvider.Email(user)
        login.login(self)
        
    }
    

    @IBAction func singUp(sender: AnyObject) {
        
        let user = PFUser()
        user.email = "belkhadirs@gmail.com"
        user.password = "123456789"
        user.username = "A"

        let userRegister = SingUp(user: user)
        userRegister.singUpUsingParse(self)
        
    }
    

    func loginProvider(navigation: UIViewController?, didFaild error: NSString) {
        
        print(error)
    
    }
    
    func loginProvider(navigation: UIViewController?, didSuccessed user: PFUser) {
        print(user)
    }

    func singUp(navigation: UIViewController?, didFaild error: NSString) {
        
        print(error)
    
    }
    
    func singUp(navigation: UIViewController?, didSingUp user: PFUser) {
        
        print(user)
    }




}













