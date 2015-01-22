//
//  SearchUsersViewController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/21/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var users = [User]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.collectionView.dataSource = self
      self.searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.users.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
    var user = self.users[indexPath.row]
    if user.avatarImage == nil {
      NetworkController.sharedNetworkController.fetchAvatarForURL(user.avatarImageURL, completionHandler: { (image) -> (Void) in
        cell.imageView.image = image
        user.avatarImage = image
        self.users[indexPath.row] = user
      })
    } else {
      cell.imageView.image = user.avatarImage
    }
    return cell
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    
    NetworkController.sharedNetworkController.fetchUsersForSearchTerm(searchBar.text, callback: { (users, error) -> (Void) in
      
      if error == nil {
        self.users = users!
        self.collectionView.reloadData()
      }
    })
  }
  
  func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is UserDetailViewController {
    return ToUserAnimationController()
    }
    return nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_USER" {
      let destinationVC = segue.destinationViewController as UserDetailViewController
      let selectedIndexPath = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
      destinationVC.selectedUser = self.users[selectedIndexPath.row]
    }
  }
}
