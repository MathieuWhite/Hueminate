//
//  TabBarController.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, BridgeDiscoveryViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color
        self.view.backgroundColor = UIColor.lightGray
        
        // Customize the tab bar color
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.translucent = false
        self.tabBar.barTintColor = UIColor.whiteColor()
        self.tabBar.tintColor = UIColor.blue
        
        // Initialize the lights view controller
        let lightsViewController = LightsViewController()
        
        // Set the tab bar's view controllers
        self.viewControllers = [lightsViewController]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If the app is not connected to a bridge, show the bridge discovery
        if (HueManager.sharedInstance.connectedBridge == nil)
        {
            // Initialize a bridge discovery view controller
            let discoveryViewController = BridgeDiscoveryViewController()
            discoveryViewController.delegate = self
            
            // Present the bridge discovery
            self.presentViewController(discoveryViewController, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - BridgeDiscoveryViewControllerDelegate Methods
    
    func pushLinkAuthenticationSuccessful(success: Bool) {
        if (success)
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            MWLog("Push link authentication was not successful")
        }
    }
}
