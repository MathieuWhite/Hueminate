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
    static let authenticationSuccess = #selector(BridgeDiscoveryViewController.authenticationSuccess)
    static let authenticationFailure = #selector(BridgeDiscoveryViewController.authenticationFailure)
    static let noLocalConnection = #selector(BridgeDiscoveryViewController.noLocalConnection)
    static let noLocalBridge = #selector(BridgeDiscoveryViewController.noLocalBridge)
    static let bridgeButtonNotPressed = #selector(BridgeDiscoveryViewController.bridgeButtonNotPressed)
}

protocol BridgeDiscoveryViewControllerDelegate: NSObjectProtocol {
    /**
     This method tells the delegate if the push link authentication was 
     successful or not.
     
     - parameter success: true if successful, false otherwise
     */
    func pushLinkAuthenticationSuccessful(success: Bool)
}

/// This ViewController is used for the bridge discovery process. 
/// When the app launches, and no bridge is connected to it, the app
/// should display this view controller and being the discovery process.
class BridgeDiscoveryViewController: UIViewController {
    
    // MARK: - Variables
    
    private weak var button: UIButton?
    
    
    /// The delegate of the BridgeDiscoveryViewController
    weak var delegate: BridgeDiscoveryViewControllerDelegate?
    
    // MARK: - Initialization
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Set the background color
        self.view.backgroundColor = UIColor.blue
        
        // Initialize the button
        let button: UIButton = UIButton(type: .System)
        button.setTitle(NSLocalizedString("Find Bridge", comment: ""), forState: .Normal)
        button.addTarget(self, action: .buttonPressed, forControlEvents: .TouchUpInside)
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
                self.startPushLinkAuthenticationWithBridge(bridge!)
            }
            else
            {
                MWLog("No bridge found")
                self.button?.enabled = true
            }
        }
    }
    
    private func startPushLinkAuthenticationWithBridge(bridge: HueBridge)
    {
        // Register for notifications about the authentication
        HueManager.sharedInstance.registerObject(self, withSelector: .authenticationSuccess, forNotificationName: PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION)
        HueManager.sharedInstance.registerObject(self, withSelector: .authenticationFailure, forNotificationName: PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION)
        HueManager.sharedInstance.registerObject(self, withSelector: .noLocalConnection, forNotificationName: PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION)
        HueManager.sharedInstance.registerObject(self, withSelector: .noLocalBridge, forNotificationName: PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION)
        HueManager.sharedInstance.registerObject(self, withSelector: .bridgeButtonNotPressed, forNotificationName: PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION)
        
        // Start the authentication process
        HueManager.sharedInstance.startPushLinkAuthentication()
        
        let label = UILabel(frame: CGRectMake(0.0, 0.0, 320.0, 44.0))
        label.text = "Push the button on your bridge"
        label.textAlignment = NSTextAlignment.Center
        label.center = self.view.center
        
        self.view.addSubview(label)
    }
    
    
    // MARK: - Authentication Notification Methods
    
    func authenticationSuccess()
    {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
        self.delegate?.pushLinkAuthenticationSuccessful(true)
    }
    
    func authenticationFailure()
    {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
        self.delegate?.pushLinkAuthenticationSuccessful(false)
    }
    
    func noLocalConnection()
    {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
        self.delegate?.pushLinkAuthenticationSuccessful(false)
    }
    
    func noLocalBridge()
    {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
        self.delegate?.pushLinkAuthenticationSuccessful(false)
    }
    
    func bridgeButtonNotPressed()
    {
        
    }
}
