//
//  Repository.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/19/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import Foundation

struct Repository {
  let name : String
  let author : String
  
  init(jsonDictionary : [String : AnyObject]) {
    self.name = jsonDictionary["name"] as String
    let ownerDictionary = jsonDictionary["owner"] as [String : AnyObject]
    self.author = ownerDictionary["login"] as String
  }
}