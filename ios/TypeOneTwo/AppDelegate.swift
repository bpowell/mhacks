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
        configureParse(launchOptions)
        configureAppearance(application)
        return true
    }

    func configureParse(launchOptions: [NSObject: AnyObject]?) {
        Parse.setApplicationId("5UjI5QS3DY6ilN8r78oZSh19lbVSH7u4RoFgRSEh", clientKey: "HKfQjDzWDzdkHuwV80gk5P13XjTAKAaxSqI7vlk6")
        PFACL.setDefaultACL(PFACL.ACL(), withAccessForCurrentUser: true)
        PFUser.enableAutomaticUser()
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
    }

    func configureAppearance(application: UIApplication) {
        UINavigationBar.appearance().barTintColor = globalThemeColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = .Black
        UITabBar.appearance().tintColor = globalThemeColor
    }
}
