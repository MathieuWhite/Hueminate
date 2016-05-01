//
//  BridgeDiscoveryViewController.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

/// Selectors used in the BridgeDiscoveryViewController.
private extension Selector {
    static let buttonPressed = #selector(BridgeDiscoveryViewController.buttonPressed)
    static let authenticationSuccess = #selector(BridgeDiscoveryViewController.authenticationSuccess)
    static let authenticationFailure = #selector(BridgeDiscoveryViewController.authenticationFailure)
    static let noLocalConnection = #selector(BridgeDiscoveryViewController.noLocalConnection)
    static let noLocalBridge = #selector(BridgeDiscoveryViewController.noLocalBridge)
    static let bridgeButtonNotPressed = #selector(BridgeDiscoveryViewController.bridgeButtonNotPressed)
}

/**
 *  This protocol notifies delegates of push link authentication with the bridge.
 */
protocol BridgeDiscoveryViewControllerDelegate: NSObjectProtocol {
    /**
     This method tells the delegate if the push link authentication was successful.
     */
    func pushLinkAuthenticationSuccessful()
}

/// This ViewController is used for the bridge discovery process. 
/// When the app launches, and no bridge is connected to it, the app
/// should display this view controller and being the discovery process.
class BridgeDiscoveryViewController: UIViewController {
    
    // MARK: - Constants
    
    /// The bridge image used when scanning the local network.
    private let bridgeImage = UIImage(named: "Bridge")?.imageWithRenderingMode(.AlwaysTemplate)
    
    /// The push link image used when waiting for authentication.
    private let pushLinkImage = UIImage(named: "PushLink")?.imageWithRenderingMode(.AlwaysTemplate)
    
    
    // MARK: - Variables
    
    /// This button is used to initiate the local bridge discovery.
    private weak var searchButton: UIButton?
    
    /// The image view that holds the bridge image or the push link image
    private weak var imageView: UIImageView?
    
    /// The delegate of the BridgeDiscoveryViewController
    weak var delegate: BridgeDiscoveryViewControllerDelegate?
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color
        self.view.backgroundColor = UIColor.blue
        
        // Initialize the search button
        let searchButton: UIButton = UIButton(type: .Custom)
        searchButton.setTitle(NSLocalizedString("Find My Bridge", comment: ""), forState: .Normal)
        searchButton.addTarget(self, action: .buttonPressed, forControlEvents: .TouchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add each component to the view
        self.view.addSubview(searchButton)
        
        // Set each component to its variable
        self.searchButton = searchButton
        
        // Auto layout
        self.setupConstraints()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the status bar to a light color
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Set the status bar back to the default color
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        MWLog("Freed: \(self)")
    }
    
    
    // MARK: - Auto Layout
    
    /**
     This method
     */
    private func setupConstraints() {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_btn"] = self.searchButton
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
    
    func buttonPressed() {
        self.searchButton?.enabled = false
        
        self.findBridge()
    }
    
    private func findBridge() {
        HueManager.sharedInstance.searchForLocalBridge { (bridge) in
            
            if (bridge != nil)
            {
                MWLog("Found bridge (\(bridge!.id)) with IP: \(bridge!.ip)")
                self.startPushLinkAuthenticationWithBridge(bridge!)
            }
            else
            {
                MWLog("No bridge found")
                self.searchButton?.enabled = true
            }
        }
    }
    
    private func startPushLinkAuthenticationWithBridge(bridge: HueBridge) {
        
        // Register for notifications about the authentication        
        HueManager.sharedInstance.registerObject(self,
                                                 withSelector: .authenticationSuccess,
                                                 forNotification: .PushLinkAuthenticationSuccessful)
        
        HueManager.sharedInstance.registerObject(self,
                                                 withSelector: .authenticationFailure,
                                                 forNotification: .PushLinkAuthenticationFailed)
        
        HueManager.sharedInstance.registerObject(self,
                                                 withSelector: .noLocalConnection,
                                                 forNotification: .PushLinkNoLocalConnection)
        
        HueManager.sharedInstance.registerObject(self,
                                                 withSelector: .noLocalBridge,
                                                 forNotification: .PushLinkNoLocalBridge)
        
        HueManager.sharedInstance.registerObject(self,
                                                 withSelector: .bridgeButtonNotPressed,
                                                 forNotification: .PushLinkButtonNotPressed)
        
        // Start the authentication process
        HueManager.sharedInstance.startPushLinkAuthentication()
        
        let label = UILabel(frame: CGRectMake(0.0, 0.0, 320.0, 44.0))
        label.text = "Push the button on your bridge"
        label.textAlignment = NSTextAlignment.Center
        label.center = self.view.center
        
        self.view.addSubview(label)
    }
    
    
    // MARK: - Authentication Notification Methods
    
    func authenticationSuccess() {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
        self.delegate?.pushLinkAuthenticationSuccessful()
    }
    
    func authenticationFailure() {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
    }
    
    func noLocalConnection() {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
    }
    
    func noLocalBridge() {
        HueManager.sharedInstance.deregisterObjectForAllNotifications(self)
    }
    
    func bridgeButtonNotPressed() {
        
    }
}
