//
//  ContainerSingInViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 05/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit

class SingInViewController:UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var singInstackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "background")
//        
//        let leadingMargin = NSLayoutConstraint(item: backgroundImage, attribute: .LeadingMargin, relatedBy:  .Equal,toItem: view, attribute: .LeadingMargin, multiplier: 1.0, constant: 0.0)
//        let topMargin = NSLayoutConstraint(item: backgroundImage, attribute: .TopMargin, relatedBy: .Equal, toItem: view, attribute: .TopMargin, multiplier: 1.0, constant: 0.0)
//        let bottomMargin = NSLayoutConstraint(item: backgroundImage, attribute: .BottomMargin, relatedBy: .Equal, toItem: view, attribute: .BottomMargin, multiplier: 1.0, constant: 0.0)
//        let traillingMargin = NSLayoutConstraint(item: backgroundImage, attribute: .TrailingMargin, relatedBy: .Equal, toItem: view, attribute: .TrailingMargin, multiplier: 1.0, constant: 0.0)
//        
//        NSLayoutConstraint.activateConstraints([leadingMargin,traillingMargin,topMargin,bottomMargin])
        
        view.insertSubview(backgroundImage, atIndex: 0)
        let stack = creatSingInButton()
        stack.hidden = true
        singInstackView.addArrangedSubview(stack)
        UIView.animateWithDuration(1.0, animations: {
            stack.hidden = false
        })
    }

    

    

    
}


extension SingInViewController {
    
    func creatSingInButton() -> UIStackView{
        let singInButton = UIButton()
        singInButton.setTitle("Sing In", forState: .Normal)
        singInButton.backgroundColor = UIColor(red: 0.0381035, green: 0.777916, blue: 0.0, alpha: 1.0)
        configureButton(singInButton)
        let stackView  = UIStackView(arrangedSubviews: [singInButton])
        stackView.axis = .Vertical
        stackView.spacing = 10.0
        stackView.alignment = .Fill
        stackView.distribution = .Fill
        singInButton.addTarget(self, action: "singIn:", forControlEvents: UIControlEvents.ValueChanged)
        return stackView
    }
    
    func singIn(sender: UIButton) {
        if !isConnectedToNetwork() {
            showAlert(.connectivity)
        }else{
            if emailText.text! != "" && passwordText.text! != "" {
                let user = User(email: emailText.text!, password: passwordText.text!)
                LoginProvider.Email(user).login(self)
            }else{
                showAlert(.unCompleteField)
            }
        }
    }
}





extension SingInViewController: LoginProviderDelegate {
    
    func loginProvider(navigation: UIViewController?, didFaild error: NSString) {
        
        
    }
    
    func loginProvider(navigation: UIViewController?, didSuccessed user: User) {
        
        let listOfMessageVC = storyboard?.instantiateViewControllerWithIdentifier("ListOfMessageViewController") as! ListOfMessageViewController
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(listOfMessageVC, animated: true, completion: nil)
        })
        
    }
    
    
    
}