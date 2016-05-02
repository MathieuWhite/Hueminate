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
    static let bridgeDiscovery = #selector(BridgeDiscoveryViewController.findBridge)
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
    
    /// The status text for the initial state.
    private let initialStatusText = NSLocalizedString("Welcome to Hueminate", comment: "")
    
    /// The status text for the discovery state.
    private let discoveryStatusText = NSLocalizedString("Searching...", comment: "")
    
    /// The status text for the authentication state.
    private let authenticationStatusText = NSLocalizedString("Your bridge was found", comment: "")

    /// The description text for the initial state.
    private let initialDescriptionText = NSLocalizedString("Thank you for downloading Hueminate.", comment: "")
    
    /// The description text for the discovery state.
    private let discoveryDescriptionText = NSLocalizedString("Searching the local network for your bridge.", comment: "")
    
    /// The description text for the authentication state.
    private let authenticationDescriptionText = NSLocalizedString("Push the button on your bridge.", comment: "")
    
    
    // MARK: - Variables
    
    /// The image view that holds the bridge image or the push link image.
    private weak var imageView: UIImageView?
    
    /// The label displaying the current status of the discovery process.
    private weak var statusLabel: UILabel?
    
    /// The label displaying the description for the current status.
    private weak var descriptionLabel: UILabel?
    
    /// The progress bar used to show the time before the authentication expires.
    private weak var progressBar: UIProgressView?
    
    /// This button is used to initiate the local bridge discovery.
    private weak var searchButton: UIButton?
    
    /// The delegate of the BridgeDiscoveryViewController
    weak var delegate: BridgeDiscoveryViewControllerDelegate?
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the background color
        self.view.backgroundColor = UIColor.blue
        
        // Initialize the image view
        let imageView = UIImageView(image: self.bridgeImage)
        imageView.tintColor = UIColor.whiteColor()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the status label
        let statusLabel = UILabel()
        statusLabel.text = self.initialStatusText
        statusLabel.textColor = UIColor.whiteColor()
        statusLabel.textAlignment = .Center
        statusLabel.font = UIFont.fontOfSize(24.0, weight: .Regular)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = self.initialDescriptionText
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.textAlignment = .Center
        descriptionLabel.font = UIFont.fontOfSize(16.0, weight: .Regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the search button
        let searchButton: UIButton = UIButton(type: .Custom)
        searchButton.setTitle(NSLocalizedString("Find My Bridge", comment: ""), forState: .Normal)
        searchButton.addTarget(self, action: .bridgeDiscovery, forControlEvents: .TouchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add each component to the view
        self.view.addSubview(imageView)
        self.view.addSubview(statusLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(searchButton)
        
        // Set each component to its variable
        self.imageView = imageView
        self.statusLabel = statusLabel
        self.descriptionLabel = descriptionLabel
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
        viewsDict["_img"] = self.imageView
        viewsDict["_status"] = self.statusLabel
        viewsDict["_desc"] = self.descriptionLabel
        viewsDict["_btn"] = self.searchButton
        viewsDict["_self"] = self.view
        
        // Metrics Dictionary
        var metricsDict: [String : AnyObject] = [String : AnyObject]()
        metricsDict["_margin"] = 40.0
        metricsDict["_spacing"] = 10.0
        
        // Vertical Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_img]-(_margin)-[_status]-(_spacing)-[_desc]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Image View Vertical Constraints
        self.view.addConstraint(NSLayoutConstraint(item: self.imageView!,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self.view,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: -80.0))
        
        // Image View Centered Horizontally
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_self]-(<=1)-[_img]",
            options: .AlignAllCenterX,
            metrics: metricsDict,
            views: viewsDict))
        
        // Status Label Horizontal Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(_margin)-[_status]-(_margin)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Description Label Horizontal Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(_margin)-[_desc]-(_margin)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Button Vertical Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_btn]-(_margin)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Button Horizontal Constraints (centered horizontally)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_self]-(<=1)-[_btn]",
            options: .AlignAllCenterX,
            metrics: metricsDict,
            views: viewsDict))
    }
    
    
    // MARK: - Instance Methods
    
    /**
     This method is called when the
     */
    func findBridge() {
        
        // Hide the button
        UIView.animateWithDuration(0.4, animations: {
            self.searchButton?.alpha = 0.0
        })
        
        // Change the status to discovery
        self.statusLabel?.text = self.discoveryStatusText
        self.descriptionLabel?.text = self.discoveryDescriptionText
        
        // Start searching for a bridge
        HueManager.sharedInstance.searchForLocalBridge { (bridge) in
            
            if (bridge != nil)
            {
                MWLog("Found bridge (\(bridge!.id)) with IP: \(bridge!.ip)")
                self.startPushLinkAuthenticationWithBridge(bridge!)
            }
            else
            {
                MWLog("No bridge found")
                UIView.animateWithDuration(0.4, animations: {
                    self.searchButton?.alpha = 1.0
                })
            }
        }
    }
    
    
    private func startPushLinkAuthenticationWithBridge(bridge: HueBridge) {
        
        // Change the status to authenticating
        self.imageView?.image = self.pushLinkImage
        self.statusLabel?.text = self.authenticationStatusText
        self.descriptionLabel?.text = self.authenticationDescriptionText
        
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
