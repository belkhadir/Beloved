//
//  FriendSearchViewController.swift
//  Beloved
//
//  Created by Anas Belkhadir on 21/01/2016.
//  Copyright © 2016 Anas Belkhadir. All rights reserved.
//

import UIKit
import CoreData

class FriendSearchViewController: UITableViewController{
    

    
    let searchController = UISearchController(searchResultsController: nil)
   

    var friendUsers = [Friend]()
    var currentUser: CurrentUserConnected?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logOut:")
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        friendUsers = fetchedAllFriend()

        
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    func fetchedAllFriend() -> [Friend] {
        let fetchedRequest = NSFetchRequest(entityName: "Friend")
        let predicate = NSPredicate(format: "currentUser = %@", CurrentUser.sharedInstance().currentUserConnected!)
        fetchedRequest.predicate = predicate
        do {
            return try sharedContext.executeFetchRequest(fetchedRequest) as! [Friend]
        }catch _ {
            return [Friend]()
        }
    }
    
    func logOut() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func setUpFirendUser() {
        FirebaseHelper.sharedInstance().getAllCurrentUserFirends({
            (error, users) in
            guard error == nil else{
                return
            }
            for (key, _) in users! {
                
                FirebaseHelper.sharedInstance().getSingleUser(key, completionHandler: {
                    (error, userInfo) in
                    guard error == nil else{
                        return
                    }
//                    self.friendUsers.append(userInfo!)
                    
                    
                })
            }
            
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendUsers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("userCell") as! FriendSearchTableViewCell


        cell.user = friendUsers[indexPath.row]

        cell.delegate = self
        return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedUser = friendUsers[indexPath.row]
        
        let listOfMessageVC = self.storyboard?.instantiateViewControllerWithIdentifier("StartchattingViewController") as! StartChattingViewController
        
        
        listOfMessageVC.friend = selectedUser
        listOfMessageVC.senderId = CurrentUser.sharedInstance().user?.userName
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController?.pushViewController(listOfMessageVC, animated: true)
        })
        
        
        
    }
    
    
}

extension FriendSearchViewController: FriendSearchTableViewCellDelegate {
    
    func cell(cell: FriendSearchTableViewCell, didSelectFriendUser user: Friend) {
        FirebaseHelper.sharedInstance().canBecomeFirend(user.uid!, willAccept: true, willBecomeFriend: {
            (_,_) in
            
         })
    
    }
    func cell(cell: FriendSearchTableViewCell, didSelectUnFriendUser user: Friend){
        FirebaseHelper.sharedInstance().canBecomeFirend(user.uid!, willAccept: false, willBecomeFriend:{
          _,_ in
        })
    }
    
}

extension FriendSearchViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let lowercaseSearchBarText = searchBar.text?.lowercaseString

        FirebaseHelper.sharedInstance().searchByUserName(lowercaseSearchBarText!, didPickUser:  {
            (exist, user) in
            if exist {
                dispatch_async(dispatch_get_main_queue()) {
                    //init the friend user
                    let userFriend = Friend(parameter: user!, context: self.sharedContext)
                    
                    userFriend.currentUser = CurrentUser.sharedInstance().currentUserConnected
                    print(CurrentUser.sharedInstance().currentUserConnected)
                    // append friendUser to array
                    self.friendUsers.insert(userFriend, atIndex: 0)
                    self.tableView.reloadData()
                    
                    // Save the context.
                    do {
                        try self.sharedContext.save()
                    } catch _ {}
                }
            }
        })
    }

}







