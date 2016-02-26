//
//  MainViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 26/02/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    

    @IBOutlet weak var singIn: UIButton!
    
    @IBOutlet weak var singUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "background")
        view.insertSubview(backgroundImage, atIndex: 0)
        configureButton(singIn)
        configureButton(singUp)
        
    }
    



}