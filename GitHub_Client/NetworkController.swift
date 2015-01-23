//
//  NetworkController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/19/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit

class NetworkController {
  
  // Singleton
  class var sharedNetworkController : NetworkController {
    struct Static {
      static let instance : NetworkController = NetworkController()
    }
    return Static.instance
  }
  
  let clientSecret = "92ce27ca3dfd9633afc764e2cc73d0824db26cbf"
  let clientID = "b4185c3188e6db730bc5"
  var urlSession : NSURLSession
  let accessTokenUserDefaultsKey : String = "access Token"
  var accessToken : String?
  
  let imageQueue = NSOperationQueue()
  
  init() {
    let ephemeralConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfiguration)
    if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsKey) as? String {
      self.accessToken = accessToken
    }
  }
  
  func requestAccessToken() {
    let url = "https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo"
    
    UIApplication.sharedApplication().openURL(NSURL(string: url)!)
  }
  
  func handleCallBackURL(url: NSURL) {
    let code = url.query
    
    let oauthURL = "https://github.com/login/oauth/access_token?\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
    let postRequest = NSMutableURLRequest(URL: NSURL(string: oauthURL)!)
    postRequest.HTTPMethod = "POST"
    
//    BODY WAY OF DOING THINGS.
//    let bodyString = "\(code!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
//    let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
//    let length = bodyData!.length
//    let postRequest = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
//    postRequest.HTTPMethod = "POST"
//    postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
//    postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//    postRequest.HTTPBody = bodyData
    
    let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          switch httpResponse.statusCode {
          case 200...299:
            println("BOOOOOM")
            
            let tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
            println(tokenResponse)
            
            let accessTokenComponent = tokenResponse?.componentsSeparatedByString("&").first as String
            let accessToken = accessTokenComponent.componentsSeparatedByString("=").last
            println(accessToken!)
            
            NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.accessTokenUserDefaultsKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            
          default:
            println("default case")
          }
        }
      }
    })
    dataTask.resume()
  }
  
  
  func fetchReposForSearchTerm(searchTerm : String, callback : ([Repository]?, String?) -> (Void)) {
    
    let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
    //Authorization: token OAUTH-TOKEN
    
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken)", forHTTPHeaderField: "Authorization")
      
//    let url = NSURL(string: "http://127.0.0.1:3000")
    
    let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, urlResponse, error) -> Void in
      
        println(urlResponse)
      
        // NSURL does not have a member named statusCode
        if let httpResponse = urlResponse as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
            println("Boom Repo")
            
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              
                if let jsonArray = jsonDictionary["items"] as? [[String : AnyObject]] {
                var allRepos = [Repository]()
                for item in jsonArray {
                  var repos = Repository(jsonDictionary: item)
                  allRepos.append(repos)
                }
                  
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                callback(allRepos, nil)
                })
              }
            }

          default:
            println("default thing happened")
          
        }
        
        println(urlResponse)
      }
      
    })
    
    dataTask.resume()
    
  }
  
  func fetchUsersForSearchTerm(searchTerm : String, callback : ([User]?, String?) -> (Void)) {
    let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
      
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
          println("Boom User")
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              
              if let itemsArray = jsonDictionary["items"] as? [[String : AnyObject]] {
                var users = [User]()
                for items in itemsArray {
                  let user = User(jsonDictionary: items)
                  users.append(user)
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  callback(users, nil)
                })
            }
          }
          default:
          println("Default User")
          }
        }
      }
    })
    
    dataTask.resume()
  }
  
  func fetchReposForUser(userName : String, completionHandler : ([Repository]?, String?) -> (Void)) {
    let url = NSURL(string: "https://api.github.com/users/\(userName)/repos")
    let request = NSMutableURLRequest(URL: url!)
    request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      if error == nil {
        if let httpResponse = response as? NSHTTPURLResponse {
          println(httpResponse.statusCode)
          switch httpResponse.statusCode {
          case 200...299:
            println("Boom fetch user repo")
            if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
              
              var manyRepos = [Repository]()
              for item in jsonArray {
                if let jsonDictionary = item as? [String : AnyObject] {
                  let repos = Repository(jsonDictionary: jsonDictionary)
                  manyRepos.append(repos)
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(manyRepos, nil)
                })
              }
            }
          default:
            println("fetch user repo default")
          }
        }
      }
    })
    dataTask.resume()
  }

  
  func fetchAvatarForURL(url : String, completionHandler : (UIImage) -> (Void)) {
    
    let url = NSURL(string: url)
    
    self.imageQueue.addOperationWithBlock { () -> Void in
      let imageData = NSData(contentsOfURL: url!)
      let image = UIImage(data: imageData!)
      
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        completionHandler(image!)
      })
    }
  }
}







