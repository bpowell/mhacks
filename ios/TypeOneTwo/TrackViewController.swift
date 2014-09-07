//
//  TrackViewController.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var insulinWebView: UIWebView!
    @IBOutlet weak var glucoseWebView: UIWebView!
    @IBOutlet weak var refreshButton: UIButton!

    var request: NSMutableURLRequest!

    override func viewDidLoad() {
        insulinWebView.delegate = self
        glucoseWebView.delegate = self
        loadGraphs()
    }

    func loadGraphs() {
        loadInsulinGraph()
        loadGlucoseGraph()
    }

    @IBAction func refreshButtonTapped(sender: UIButton!) {
        loadGraphs()
        SVProgressHUD.show()
        finished = 0
        UIView.animateWithDuration(0.4) {
            self.refreshButton.alpha = 0
            self.insulinWebView.alpha = 0
            self.glucoseWebView.alpha = 0
        }
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

    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }

    var finished = 0
    func webViewDidFinishLoad(webView: UIWebView) {
        if (finished++ > 0) {
            SVProgressHUD.dismiss()
            UIView.animateWithDuration(0.4) {
                self.refreshButton.alpha = 1
                self.insulinWebView.alpha = 1
                self.glucoseWebView.alpha = 1
            }
        }
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        finished = 1
        SVProgressHUD.dismiss()
        UIView.animateWithDuration(0.4) {
            self.refreshButton.alpha = 1
            self.insulinWebView.alpha = 1
            self.glucoseWebView.alpha = 1
        }
    }

}
