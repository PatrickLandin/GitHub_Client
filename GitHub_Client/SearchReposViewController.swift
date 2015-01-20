//
//  SearchReposViewController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/19/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class SearchReposViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  let networkController = NetworkController()
  var repository = [Repository]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.tableView.dataSource = self
      self.searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
  
  //MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.repository.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL", forIndexPath: indexPath) as UITableViewCell
    
    cell.textLabel?.text = self.repository[indexPath.row].author
    cell.detailTextLabel?.text = self.repository[indexPath.row].name
    
    return cell
  }

  //MARK: UISearchBarDelegate
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    println(searchBar.text)
    self.searchBar.resignFirstResponder()
    
    self.networkController.fetchReposForSearchTerm(self.searchBar.text, callback: { (items, error) -> (Void) in
      if error == nil {
        
        self.repository = items!
        
        self.tableView.reloadData()
      } else {
        println("bad stuff happened")
      }
      
    })
  }

}