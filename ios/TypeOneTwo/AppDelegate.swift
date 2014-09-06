//
//  AppDelegate.swift
//  TypeOneTwo
//
//  Created by andrew on 9/6/14.
//  Copyright (c) 2014 TypeOneTwo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh", clientKey: "HKfQjDzWDzdkHuwV80gk5P13XjTAKAaxSqI7vlk6")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }

}
