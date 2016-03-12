//
//  ContainerSingInViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 05/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import CoreData


class SingInViewController:UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    @IBOutlet weak var singInstackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "background")
        view.insertSubview(backgroundImage, atIndex: 0)
        
      

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    @IBAction func singIn(sender: UIButton) {

        if !isConnectedToNetwork() {
            sender.enabled = false
            showAlert(.connectivity)
        }else{
            if emailText.text! != "" && passwordText.text! != "" {
                let user = User(email: emailText.text!, password: passwordText.text!)
                
                LoginProvider.Email(user).login(self)
            }else{
                sender.enabled = false

                showAlert(.unCompleteField)
            }
        }
    }
    
}

extension SingInViewController: LoginProviderDelegate {
    
    func loginProvider(navigation: UIViewController?, didFaild error: NSString) {
        showAlert(.custom("Faild",error as String))
        
    }
    
    func loginProvider(navigation: UIViewController?, didSuccessed user: User) {
        CurrentUser.sharedInstance().user = user
        let dictionary: [String: AnyObject] = [FirebaseHelper.JSONKEY.USERNAME: user.userName!,
            FirebaseHelper.JSONKEY.UID: user.uid!
        ]
        let listOfMessageVC = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
       
        dispatch_async(dispatch_get_main_queue(), {
            let current = CurrentUserConnected(parameter: dictionary, context: self.sharedContext)
            
            do {
                try self.sharedContext.save()
            } catch _ {}
            
            CurrentUser.sharedInstance().currentUserConnected = current
            self.navigationController?.pushViewController(listOfMessageVC, animated: true)
        })
    }
}















