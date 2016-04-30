//
//  AppDelegate.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The main window of the application.
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize the window
        let window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Initialize the tab bar controller
        let tabBarController = TabBarController()
        
        // Initialize the navigation controller
        let navigationController = NavigationController(rootViewController: tabBarController)
        
        // Set the root view controller and make visible
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Set the reference to the window
        self.window = window
        
        // If the app is already connected to a bridge, start the local heartbeat
        if (HueManager.sharedInstance.connectedBridge != nil)
        {
            HueManager.sharedInstance.enableLocalHeartbeat()
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Stop the heartbeat
        HueManager.sharedInstance.disableLocalHeartbeat()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Start the heartbeat
        HueManager.sharedInstance.enableLocalHeartbeat()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


// MARK: - Debugging Logger

/**
 Logs the message passed to the method when in debug only.
 
 - parameter message:  the message to print to to console
 - parameter file:     the file that called the logging function
 - parameter function: the function the log was called from
 - parameter line:     the line number in the file
 */
func MWLog(message: String, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        print("\(NSDate()) [\(file):\(line)] \(function) > \(message)")
    #endif
}

