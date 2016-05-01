//
//  NavigationController.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color 
        self.view.backgroundColor = UIColor.lightGray

        // Customize the navigation bar color
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = UIColor.whiteColor()
        
        // Customize the navigation bar title
        let titleTextAttributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.darkGray,
            NSFontAttributeName : UIFont.navigationBarFont
        ]
        
        // Set the title attributes
        self.navigationBar.titleTextAttributes = titleTextAttributes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the status bar
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        MWLog("Freed: \(self)")
    }
}
