//
//  SearchUsersViewController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/21/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

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
    
    return cell
  }
  
}
