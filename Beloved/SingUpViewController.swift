//
//  ContainerSingUpViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 05/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import Foundation

class SingUpViewController: UIViewController ,
                            UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate{
    
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var birthDateStackView: UIStackView!

    @IBOutlet weak var birthdateButton: UIButton!
    @IBOutlet weak var imagePicker: UIButton!

    @IBOutlet weak var usernameText: UITextField!
    
    var isKeyBoardUp: Bool = false
    private var datePickerContentStackView : UIStackView?
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameText.delegate = self
        lastNameText.delegate  = self
        
        imagePicker.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        navigationItem.title = "Lest's Get Start"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SingUp", style: .Plain , target: self, action: "singUp:")
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        addKeyboardDismissRecognizer()
        

    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotification()
        
    }
    
    @IBAction func handleShowHideDatePicker(sender: UIButton) {
        if datePickerContentStackView   == nil {
            datePickerContentStackView = creatDatePicker()
            datePickerContentStackView?.hidden = true
            birthDateStackView.addArrangedSubview(datePickerContentStackView!)
            UIView.animateWithDuration(0.5, animations: {
                self.datePickerContentStackView?.hidden = false
            })
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.datePickerContentStackView?.hidden = true
                }, completion: {
                    (_) -> Void in
                    self.datePickerContentStackView?.removeFromSuperview()
                    self.datePickerContentStackView = nil
            })
         
        }
        
    }
    
    @IBAction func importImage(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    
    func singUp(sender: UIButton) {
        sender.enabled = true
        if !isConnectedToNetwork(){
            showAlert(.connectivity)
            sender.enabled = false
        }
        if emailText.text! != "" && firstNameText.text! != ""  
              &&  lastNameText.text! != "" && usernameText.text! != ""
              && passwordText.text! != ""   {
                
                let parameter = [
                    FirebaseHelper.JSONKEY.EMAIL: emailText.text!,
                    FirebaseHelper.JSONKEY.FIRST_NAME: firstNameText.text!,
                    FirebaseHelper.JSONKEY.LAST_NAME: lastNameText.text!,
                    FirebaseHelper.JSONKEY.USERNAME: usernameText.text!,
                    FirebaseHelper.JSONKEY.PASSWORD : passwordText.text!,
                    FirebaseHelper.JSONKEY.DATE : "\(birthdateButton.titleLabel?.text!)",
                    FirebaseHelper.JSONKEY.IMAGE : imageEncodedBase64(imagePicker.imageView?.image)! ?? ""
                ]
                let user = User(parameter: parameter)
                SingUp.Email(user).singUp(self)
        }else {
            sender.enabled = false
            showAlert(.unCompleteField)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let circle = image.circle
            self.imagePicker.setImage(circle, forState: .Normal)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
}



extension SingUpViewController : SingUpDelegate{
    
    
    func singUp(navigation: UIViewController?, didFaild error: NSString) {
        
        showAlert(.custom("error",error as String))
    }
    
    func singUp(navigation: UIViewController?, didSingUp user: User) {
        CurrentUser.sharedInstance().user = user
        let listOfMessageVC = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController?.pushViewController(listOfMessageVC, animated: true)
        })
        
        
    }
    
}

extension SingUpViewController {
    
    private func creatDatePicker() -> UIStackView {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.backgroundColor = UIColor.whiteColor()
        let stackView = UIStackView(arrangedSubviews: [datePicker])
        stackView.axis = .Vertical
        stackView.spacing = 10.0
        stackView.alignment = .Center
        stackView.distribution = .EqualCentering
        datePicker.addTarget(self, action: "handleDatePciker:", forControlEvents: UIControlEvents.ValueChanged)
        return stackView
    }
    
    func handleDatePciker(sender: UIDatePicker) {
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "dd mm yyy"
        birthdateButton.setTitle(dateFormater.stringFromDate(sender.date), forState: .Normal)
        birthdateButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
}


//Mark: Keyboard

extension SingUpViewController: UITextFieldDelegate {

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        isKeyBoardUp = true
        if firstNameText.editing || lastNameText.editing {
            if isKeyBoardUp {
                view.frame.origin.y = 0
                isKeyBoardUp = false
            }
        }else if emailText.editing || passwordText.editing {
            if isKeyBoardUp{
                view.frame.origin.y = 0
                view.frame.origin.y -= getKeyboardHeight(notification)/2
                isKeyBoardUp = false
            }
        }else {
            if isKeyBoardUp {
                view.frame.origin.y = 0
                view.frame.origin.y -= getKeyboardHeight(notification)
                isKeyBoardUp = false
            }
        }
        
    }
    
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification){
        isKeyBoardUp = true
        if firstNameText.editing || lastNameText.editing {
            if isKeyBoardUp {
                view.frame.origin.y = 0
                isKeyBoardUp = false
            }
        }else if emailText.editing || passwordText.editing {
            if isKeyBoardUp{
                view.frame.origin.y = 0
                view.frame.origin.y += getKeyboardHeight(notification)/2
                isKeyBoardUp = false
            }
        }else {
            if isKeyBoardUp {
                view.frame.origin.y = 0
                 view.frame.origin.y += getKeyboardHeight(notification)
                isKeyBoardUp = false
            }
        }
    }

    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}








