//
//  NetworkController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/19/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import Foundation

class NetworkController {
  
  var urlSession : NSURLSession
  
  init() {
    let ephemeralConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    self.urlSession = NSURLSession(configuration: ephemeralConfiguration)
  }
  
  func fetchReposForSearchTerm(searchTerm : String, callback : ([Repository]?, String?) -> (Void)) {
    
    let url = NSURL(string: "http://127.0.0.1:3000")
    
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
}
