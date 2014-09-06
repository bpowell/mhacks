//
//  TrackViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        sendPost()
    }

    func sendPost() {
        let token = PFUser.currentUser().sessionToken
        let post = "sessiontoken=\(token)"
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength = "\(postData.length)"
        let request = NSMutableURLRequest()

        request.URL = NSURL(string: "http://162.243.245.232:8081/post")
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData

        webView.loadRequest(request)
    }

}
