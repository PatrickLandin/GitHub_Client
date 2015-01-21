//
//  User.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/21/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

struct User {
  var name : String
  var avatarImageURL : String
  var avatarImage : UIImage?
  
  init(jsonDictionary : [String : AnyObject]) {
    self.name = jsonDictionary["login"] as String
    self.avatarImageURL = jsonDictionary["avatar_url"] as String
  }
  
}