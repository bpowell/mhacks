//
//  TrackViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {

    @IBOutlet weak var insulinWebView: UIWebView!
    @IBOutlet weak var glucoseWebView: UIWebView!

    var request: NSMutableURLRequest!

    override func viewDidLoad() {
        loadGraphs()
    }

    func loadGraphs() {
        loadInsulinGraph()
        loadGlucoseGraph()
    }

    @IBAction func refreshButtonTapped(sender: UIButton!) {
        loadGraphs()
    }

    func loadInsulinGraph() {
        prepareRequestForURL("http://162.243.245.232:8081/insulinGraph")
        insulinWebView.loadRequest(request)
    }

    func loadGlucoseGraph() {
        prepareRequestForURL("http://162.243.245.232:8081/glucoseGraph")
        glucoseWebView.loadRequest(request)
    }

    func prepareRequestForURL(URLString: String) {
        let token = PFUser.currentUser().sessionToken
        let post = "sessiontoken=\(token)"
        let postData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength = "\(postData.length)"
        request = NSMutableURLRequest()

        request.URL = NSURL(string: URLString)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
    }

}
