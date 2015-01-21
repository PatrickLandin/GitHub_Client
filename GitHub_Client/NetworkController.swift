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
            println("Boom. HTTP response worked")
            
            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
              
              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if let jsonArray = jsonDictionary["items"] as? [[String : AnyObject]] {
                var allRepos = [Repository]()
                for item in jsonArray {
                  var repos = Repository(jsonDictionary: item)
                  allRepos.append(repos)
                }
                
                callback(allRepos, nil)
                }
              })
            }

          default:
            println("default thing happened")
          
        }
        
        println(urlResponse)
      }
      
    })
    
    dataTask.resume()
    
  }
  
  fetchUsersForSearch
}
