//
//  FriendSearchTableViewCell.swift
//  Beloved
//
//  Created by Anas Belkhadir on 21/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit


protocol FriendSearchTableViewCellDelegate : class {
    
    func cell(cell: FriendSearchTableViewCell, didSelectFriendUser user: User)
    func cell(cell: FriendSearchTableViewCell, didSelectUnFriendUser user: User)
    
}

class FriendSearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var friendButton: UIButton!
    
    
    weak var delegate: FriendSearchTableViewCellDelegate?
    
    var user: User? {
        didSet {
            username.text = "\(user!.email)"
            imageProfile.image = imageDecodeBase64(user?.image64EncodeImage)
            
        }
    }
    
    var canBecomeFriend: Bool? = true {
        didSet {
            
            /*
            Change the state of the friend button based on whether or not
            it is possible to follow a user.
            */
            
            if let canBecomeFriend = canBecomeFriend {
                friendButton.setImage(<#T##image: UIImage?##UIImage?#>, forState: .Selected)
                friendButton.selected   = !canBecomeFriend
            }
            
        }
    }
    
    
    
    
    
    @IBAction func friendButtonTapped(sender: UIButton) {
        
        if let canBecomeFriend = canBecomeFriend where canBecomeFriend == true {
            
            delegate?.cell(self, didSelectFriendUser: user!)
            self.canBecomeFriend = false
            
        }else{
            delegate?.cell(self, didSelectFriendUser: user!)
            canBecomeFriend = true
        }
        
        
    }
}
