//
//  WebViewController.swift
//  GitHub_Client
//
//  Created by Patrick Landin on 1/22/15.
//  Copyright (c) 2015 Patrick Landin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
  
  let webView = WKWebView()
  var repoURL : String!

    override func viewDidLoad() {
        super.viewDidLoad()
      self.navigationController?.delegate = nil
      // This prevents a crash when navigating back to UserDetailVC after visiting WebVC.
      // Navigation controller delegate continues to look for zombie animation.
      
      self.webView.frame = self.view.frame
      self.view.addSubview(webView)
      self.webView.setTranslatesAutoresizingMaskIntoConstraints(false)
      let views = ["webView" : self.webView]
      
      let webViewConstraintHorizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: nil, metrics: nil, views: views)
      view.addConstraints(webViewConstraintHorizontal)
      let webViewConstraintVertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: nil, metrics: nil, views: views)
      view.addConstraints(webViewConstraintVertical)
      
      let request = NSURLRequest(URL: NSURL(string: self.repoURL)!)
      self.webView.loadRequest(request)

        // Do any additional setup after loading the view.
    }
  
}
