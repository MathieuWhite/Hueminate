//
//  LightsViewController.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

/// Selectors used in the LightsViewController.
private extension Selector {
    static let buttonPressed = #selector(LightsViewController.buttonPressed)
}

/// This view controller is used to display the status of the lights.
class LightsViewController: UIViewController {

    // MARK: - Variables
    
    private weak var titleLabel: UILabel?
    private weak var button: UIButton?
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view
        self.title = NSLocalizedString("My Lights", comment: "")
        self.tabBarController?.title = NSLocalizedString("My Lights", comment: "")
        
        // Set the background color
        self.view.backgroundColor = UIColor.lightGray
        
        // Initialize the title label
        let titleLabel = UILabel()
        titleLabel.text = String.localizedStringWithFormat("Connected to %@", HueManager.sharedInstance.connectedBridge?.name ?? "n/a")
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        titleLabel.textColor = UIColor.darkTextColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize the button
        let button: UIButton = UIButton(type: UIButtonType.System)
        button.setTitle(NSLocalizedString("Randomize Lights", comment: ""), forState: UIControlState.Normal)
        button.addTarget(self, action: .buttonPressed, forControlEvents: UIControlEvents.TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(button)
        
        self.titleLabel = titleLabel
        self.button = button
        
        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Auto Layout
    
    private func setupConstraints() {
        // Views Dictionary
        var viewsDict: [String : AnyObject] = [String : AnyObject]()
        viewsDict["_lbl"] = self.titleLabel
        viewsDict["_btn"] = self.button
        viewsDict["_self"] = self.view
        
        // Metrics Dictionary
        var metricsDict: [String : AnyObject] = [String : AnyObject]()
        metricsDict["_margin"] = 100.0
        metricsDict["_btnV"] = 40.0
        
        // Button Vertical Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_btn]-(100.0)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Button Horizontal Constraints (centered horizontally)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_self]-(<=1)-[_btn]",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: metricsDict,
            views: viewsDict))
        
        // Label Vertical Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(100.0)-[_lbl]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
        
        // Label Horizontal Constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(40.0)-[_lbl]-(40.0)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: metricsDict,
            views: viewsDict))
    }
    
    
    // MARK: - Instance Methods
    
    func buttonPressed() {
        self.button?.enabled = false
        
        HueManager.sharedInstance.randomizeAllLights()
        
        self.button?.enabled = true
    }

}
