//
//  UserDetailViewController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/21/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDataSource {
  
  var selectedUser : User!
  var userRepostories = [Repository]()

  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.userNameLabel.text = self.selectedUser.name
      self.userImageView.image = selectedUser.avatarImage
      self.userImageView.layer.masksToBounds = true
      self.userImageView.layer.cornerRadius = 10.0
      self.tableView.dataSource = self
      
//      NetworkController.sharedNetworkController
    
        // Do any additional setup after loading the view.
    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userRepostories.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("USER_REPOCELL", forIndexPath: indexPath) as UITableViewCell
    
    let selectedUser = self.userRepostories[indexPath.row]
    cell.textLabel?.text = selectedUser.author
    cell.detailTextLabel?.text = selectedUser.repoURL
    
    return cell
  }

}
