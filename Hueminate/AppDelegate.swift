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
        
        // Start the local heartbeat
        HueManager.sharedInstance.enableLocalHeartbeat()
        
        // Initialize the window
        let window: UIWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Initialize the navigation controller
        let navigationController = NavigationController(rootViewController: UIViewController())
        
        // If the app isn't connected to a bridge, begin the discovery process
        if (HueManager.sharedInstance.connectedBridge == nil)
        {
            // Initialize a bridge discovery view controller
            let discoveryViewController = BridgeDiscoveryViewController()
            navigationController.pushViewController(discoveryViewController, animated: false)
        }
        
        // Set the root view controller and make visible
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Set the reference to the window
        self.window = window
        
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

