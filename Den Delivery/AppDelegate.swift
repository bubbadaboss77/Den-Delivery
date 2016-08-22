//
//  AppDelegate.swift
//  Den Delivery
//
//  Created by Tim on 5/27/16.
//  Copyright © 2016 Bobcat Den Delivery. All rights reserved.
//

import UIKit
import Firebase

// GLOBALS
let darkRedColor = UIColor(colorLiteralRed: 0.533, green: 0.063, blue: 0.141, alpha: 1.0) // #881024
let lightRedColor = UIColor(colorLiteralRed: 0.8, green: 0.094, blue: 0.212, alpha: 1.0) // #CC1836

let placeholderFont = UIFont(name: "Avenir Next", size: 16)
let formTextFont = UIFont(name: "AvenirNext-Medium", size: 16)

let firebaseRef = FIRDatabase.database().reference()

// NSNotificatin Center Config
let openStatusChangedNotificationKey = "com.bdd.openStatusChangedNotification"

// DD open/closed?
var openForDelivery = false {
    didSet {
        NSNotificationCenter.defaultCenter().postNotificationName(openStatusChangedNotificationKey, object: nil)
        print("openForDelivery value changed: \(openForDelivery)")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initialize Firebase
        FIRApp.configure()
        
        // Ask user for push notifications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        FirebaseController.sharedController.openStatusChangedObserver { (success) in
            if !success {
                ProgressHUD.showError("Network connection failed")
            }
        }
        
        // Global Appearance
        UITextField.appearance().font = UIFont(name: "AvenirNext-Medium", size: 16)
        UITabBar.appearance().tintColor = lightRedColor
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
//        print("Firebase device token: \(FIRInstanceID.instanceID().token()!)")
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // Push notifications
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }


}

