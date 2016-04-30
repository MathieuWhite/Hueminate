//
//  BridgeDiscoveryViewController.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

private extension Selector {
    static let buttonPressed = #selector(BridgeDiscoveryViewController.buttonPressed)
}

/// This ViewController is used for the bridge discovery process. 
/// When the app launches, and no bridge is connected to it, the app
/// should display this view controller and being the discovery process.
class BridgeDiscoveryViewController: UIViewController {
    
    // MARK: - Variables
    
    private weak var button: UIButton?
    
    
    // MARK: - Initialization
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Set the background color
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Initialize the button
        let button: UIButton = UIButton(type: UIButtonType.System)
        button.setTitle(NSLocalizedString("Find Bridge", comment: ""), forState: UIControlState.Normal)
        button.addTarget(self, action: .buttonPressed, forControlEvents: UIControlEvents.TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button to the view
        self.view.addSubview(button)
        
        self.button = button
        
        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        MWLog("Freed: \(self)")
    }
    
    
    // MARK: - Auto Layout
    
    private func setupConstraints()
    {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_btn"] = self.button
        viewsDict["_self"] = self.view
        
        // Metrics Dictionary
        var metricsDict: [String : AnyObject] = [String : AnyObject]()
        metricsDict["_btnV"] = 40.0
        
        // Button Vertical Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_btn]-(_btnV)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Button Horizontal Constraints (centered horizontally)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_self]-(<=1)-[_btn]",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: metricsDict,
            views: viewsDict))
    }
    
    
    // MARK: - Instance Methods
    
    func buttonPressed()
    {
        self.button?.enabled = false
        
        self.findBridge()
    }
    
    private func findBridge()
    {
        HueManager.sharedInstance.searchForLocalBridge { (bridge) in
            
            if (bridge != nil)
            {
                MWLog("Found bridge (\(bridge!.id)) with IP: \(bridge!.ip)")
                self.promptToConnectToBridge(bridge!)
            }
            else
            {
                MWLog("No bridge found")
                self.button?.enabled = true
            }
        }
    }
    
    private func promptToConnectToBridge(bridge: HueBridge)
    {
        let alertController = UIAlertController(title: NSLocalizedString("Bridge Found", comment: ""),
                                                message: NSLocalizedString("Would you like to connect to it?", comment: ""),
                                                preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""),
            style: .Default,
            handler: { (action) in
                self.startPushLinkAuthenticationWithBridge(bridge)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""),
            style: .Cancel,
            handler: nil))
        
        
        self.presentViewController(alertController, animated: true, completion: {
            self.button?.enabled = true
        })
        
    }
    
    private func startPushLinkAuthenticationWithBridge(bridge: HueBridge)
    {
        HueManager.sharedInstance.startPushLinkAuthenticationWithBridge(bridge)
        
        let label = UILabel(frame: CGRectMake(0.0, 0.0, 320.0, 44.0))
        label.text = "Push the button on your bridge"
        label.textAlignment = NSTextAlignment.Center
        label.center = self.view.center
        
        self.view.addSubview(label)
    }
}
