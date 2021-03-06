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
    

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
   

    var friendUsers = [Friend]()
    var currentUser: CurrentUserConnected?
    
    //it's make easy to know fetchAllFriendFromFirebase function start getting data from the server
    var startGettingFriendFromFirebase: Bool = false {
        didSet {
            if startGettingFriendFromFirebase {
                activityIndicator.startAnimating()
                activityIndicator.hidden = false
            }else{
                activityIndicator.stopAnimating()
                activityIndicator.hidden = true
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.hidden = true
        self.activityIndicator.stopAnimating()
        navigationController?.navigationBar.topItem?.title = "Logout"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logOut:")
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        
        friendUsers = fetchedAllFriend()
        
        //if ther's no friend saved in CoreData look at his friend on the server
        if friendUsers.count == 0 {
            fetchAllFriendFromFirebase()
        }

        
    }

    
    //fetch all friend from the server
    func fetchAllFriendFromFirebase() {
        
        //Mark- start getting data from server
        startGettingFriendFromFirebase = true
        
        FirebaseHelper.sharedInstance().getAllCurrentUserFirends({
            userIdKey in

            for element in self.friendUsers {
                if element.uid == userIdKey! {
                    self.startGettingFriendFromFirebase = false
                    return
                }
            }
            
            FirebaseHelper.sharedInstance().getSingleUser(userIdKey!, completionHandler: {
                (error, userFriend) in
                guard error == nil else{
                    self.startGettingFriendFromFirebase = false
                    self.showAlert(.custom("erro occur", error!))
                    return
                }
                
                //The user friend was picked from the server
                //we need to make a new Friend. To be easy to save in CoreData
                //The easiest way to do that is to make a dictionary.
                
                let dictionary: [String : AnyObject] = [
                    Friend.Keys.username: userFriend!.userName!,
                    Friend.Keys.uid: userIdKey!,
                ]
                
                // Insert the Friend on the main thread
                dispatch_async(dispatch_get_main_queue(), {
                
                    //Init - Friend user 
                    let friendToBeAdd = Friend(parameter: dictionary, context: self.sharedContext)
                
                    friendToBeAdd.currentUser = CurrentUser.sharedInstance().currentUserConnected!
                    
                    self.friendUsers.append(friendToBeAdd)

                    self.tableView.reloadData()
                    self.startGettingFriendFromFirebase = false                    
                    //Save in the context
                    CoreDataStackManager.sharedInstance().saveContext()
                })
                
                
            })
            
        })
        startGettingFriendFromFirebase = false
        
        //Mark- finishing getting data from server
        
    }
    
    

    
    
    
    
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }

    
    //fetch all friend from the CoreData
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
        
        FirebaseHelper.sharedInstance().messageRef.removeAllObservers()
        FirebaseHelper.sharedInstance().userRef.removeAllObservers()
        FirebaseHelper.sharedInstance().ref.unauth()
        
        
        //using presentViewController instead of pushViewController because:
        //when the first time user singUp and try to logout it's showing the 
        //previews task .
        let nvg = storyboard?.instantiateViewControllerWithIdentifier("singInViewController") as! SingInViewController
        navigationController?.presentViewController(nvg, animated: true, completion: nil)
        

    }
    
    

    
    
    
    // MARK: - Table View
    
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
        
        if !isConnectedToNetwork() {
            showAlert(.connectivity)
            return
        }
        
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        let lowercaseSearchBarText = searchBar.text?.lowercaseString

        // Check to see if we already have this friend . If so , return
        if let _ = friendUsers.indexOf({$0.username == lowercaseSearchBarText}) {
            return
        }
        
        FirebaseHelper.sharedInstance().searchByUserName(lowercaseSearchBarText!, didPickUser:  {
            (exist, user) in

            if exist {
                
                // Insert the Friend on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    //init the friend user
                    let userFriend = Friend(parameter: user!, context: self.sharedContext)
                    
                    //Mark - relation
                    userFriend.currentUser = CurrentUser.sharedInstance().currentUserConnected!
                    
                    // append friendUser to array
                    self.friendUsers.insert(userFriend, atIndex: 0)
                    self.tableView.reloadData()
                    
                    // Save the context.
                    do {
                        try self.sharedContext.save()
                    } catch _ {}
                }
            }
            self.activityIndicator.hidden = true
            self.activityIndicator.stopAnimating()
        })

    }

}







