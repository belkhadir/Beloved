//
//  ProfileViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 29/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        firstName.text = CurrentUser.sharedInstance().user?.firstName
        lastName.text = CurrentUser.sharedInstance().user?.lastName
        email.text = CurrentUser.sharedInstance().user?.email
        userName.text = CurrentUser.sharedInstance().user?.userName
        birthday.text = CurrentUser.sharedInstance().user?.date
        imageProfile.image = imageDecodeBase64(CurrentUser.sharedInstance().user?.image64EncodeImage)
    
    }
    
    
}