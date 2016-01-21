//
//  FriendSearchViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 21/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import Parse

class FriendSearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var users: [PFUser]?
    
    var friendUsers: [PFUser]? {
       
        didSet {
            
            tableView.reloadData()
        }
    }
    
    
    var querry: PFQuery? {
        
        didSet {
            oldValue?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension FriendSearchViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell") as! FriendSearchTableViewCell
        
        let user = users![indexPath.row]
        cell.user = user
        
        if let friendUsers = friendUsers {
            
            cell.canBecomeFriend = !friendUsers.contains(user)
        }
        
        cell.delegate = self
        
        return cell
        
    }
}

extension FriendSearchViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    
}


extension FriendSearchViewController: FriendSearchTableViewCellDelegate {
    
    func cell(cell: FriendSearchTableViewCell, didSelectUnFriendUser user: PFUser) {
        
        //When the user tap on user isn't friend he send request to become friend
        // send push notification
        
        
        
    }
    
    func cell(cell: FriendSearchTableViewCell, didSelectFriendUser user: PFUser) {
        //When the user tap on user is his friend just unfriend 
        //
        
        
        
    }
    
}







