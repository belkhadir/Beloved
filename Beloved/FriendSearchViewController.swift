//
//  FriendSearchViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 21/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit


class FriendSearchViewController: UITableViewController {
    

    
    let searchController = UISearchController(searchResultsController: nil)
   
    
    
    var user: User?
    
    var friendUsers: [User]? {
       
        didSet {
            
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return users?.count ?? 0
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell")
        
        cell?.textLabel?.text = user?.firstName
        
        
        
        

        

        if let friendUsers = friendUsers {
            
            // cell.canBecomeFriend = !friendUsers.contains(user)
        }
        
//        cell.delegate = self
        
        return cell!
        
    }
    
}



extension FriendSearchViewController: UISearchBarDelegate{

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let lowercaseSearchBarText = searchBar.text?.lowercaseString

        FirebaseHelper.sharedInstance().searchByUserName(lowercaseSearchBarText!, didPickUser:  {
            (exist, user) in
            if exist {
                self.user = user
                self.tableView.reloadData()
            }
        })
    }

}



extension FriendSearchViewController: FriendSearchTableViewCellDelegate {
    
    func cell(cell: FriendSearchTableViewCell, didSelectUnFriendUser user: User) {
        
        //When the user tap on user isn't friend he send request to become friend
        // send push notification
        
        
        
    }
    
    func cell(cell: FriendSearchTableViewCell, didSelectFriendUser user: User) {
        //When the user tap on user is his friend just unfriend 
        //
        
        
        
    }
    
}







