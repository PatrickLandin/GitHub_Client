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
  @IBOutlet weak var userURL: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.userNameLabel.text = self.selectedUser.name
      self.userImageView.image = self.selectedUser.avatarImage
      self.userURL.text = self.selectedUser.userURL
      self.userImageView.layer.masksToBounds = true
      self.userImageView.layer.cornerRadius = 10.0
      self.tableView.dataSource = self
      
      NetworkController.sharedNetworkController.fetchReposForUser(self.selectedUser.name, completionHandler: { (repos, error) -> (Void) in
        if error == nil {
          self.userRepostories = repos!
          self.tableView.reloadData()
        } else {
          println("Dammmit!!!")
        }
      })
    
        // Do any additional setup after loading the view.
    }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userRepostories.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("USER_REPOCELL", forIndexPath: indexPath) as UITableViewCell
    
    let selectedUser = self.userRepostories[indexPath.row]
    cell.textLabel?.text = selectedUser.name
    cell.detailTextLabel?.text = selectedUser.repoURL
    
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SHOW_WEB" {
      let destinationVC = segue.destinationViewController as WebViewController
      let selectedIndexPath = self.tableView.indexPathForSelectedRow()
      let repo = self.userRepostories[selectedIndexPath!.row]
      destinationVC.repoURL = repo.repoURL
    }
  }


}
