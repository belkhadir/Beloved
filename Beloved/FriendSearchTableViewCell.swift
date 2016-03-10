//
//  FriendSearchTableViewCell.swift
//  Beloved
//
//  Created by Anas Belkhadir on 21/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit


protocol FriendSearchTableViewCellDelegate : class {
    
    func cell(cell: FriendSearchTableViewCell, didSelectFriendUser user: Friend)
    func cell(cell: FriendSearchTableViewCell, didSelectUnFriendUser user: Friend)
    
}

class FriendSearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var friendButton: UIButton!
    
    
    weak var delegate: FriendSearchTableViewCellDelegate?
    
    var user: Friend? {
        didSet {
            username.text = user?.username
            FirebaseHelper.sharedInstance().canBecomeFirend(user!.uid!, didBecomeFriend: {
                status in
                if status == nil {
                    self.friendButton.setImage(UIImage(imageLiteral: "add"), forState: .Normal)
                }else if status! {
                    self.friendButton.setImage(UIImage(imageLiteral: "cancel"), forState: .Normal)
                }else{
                    self.friendButton.setImage(UIImage(imageLiteral: "add"), forState: .Normal)
                }
            })
//            imageProfile.image = imageDecodeBase64(user?.image64EncodeImage)
            
        }
    }
    
    var canBecomeFriend: Bool? = true {
        didSet {
            

            if let canBecomeFriend = canBecomeFriend {
                
                friendButton.selected   = !canBecomeFriend
            }
        }
    }
    
    
    
    @IBAction func friendButtonTapped(sender: UIButton) {
        
        if let canBecomeFriend = canBecomeFriend where canBecomeFriend == true {
            sender.setImage(UIImage(imageLiteral: "cancel"), forState: .Normal)
            
            delegate?.cell(self, didSelectFriendUser: user!)
            self.canBecomeFriend = false
            
        }else{
            sender.setImage(UIImage(imageLiteral: "add"), forState: .Normal)
            delegate?.cell(self, didSelectFriendUser: user!)
            canBecomeFriend = true
        }
        
        
    }
}
