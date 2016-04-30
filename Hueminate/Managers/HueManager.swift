//
//  HueManager.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

/// The HueBridge structure represents a bridge
/// before it's connected to the app. All we know
/// about it is the BridgeID and IP Address.
struct HueBridge
{
    var id = ""
    var ip = ""
}

/// The HueColor structure represents the way a color is 
/// represented on the Philips Hue lights.
struct HueColor
{
    var hue: CGFloat        = -1.0
    var saturation: CGFloat = -1.0
    var brightness: CGFloat = -1.0
}

/// The HueManager is a singleton instance that manages
/// the Philips Hue lights from the app.
class HueManager: NSObject
{
    // MARK: - Singleton
    
    /// The shared instance of the HueManager.
    static let sharedInstance: HueManager = HueManager()
    
    
    // MARK: - Color Constants
    
    /// The minimum hue value allowed.
    let minHue: CGFloat        = 0.0
    
    /// The maximum hue value allowed.
    let maxHue: CGFloat        = 65535.0
    
    /// The minimum saturation value allowed.
    let minSaturation: CGFloat = 0.0
    
    /// The maximum saturation value allowed.
    let maxSaturation: CGFloat = 254.0
    
    /// The minimum brightness value allowed.
    let minBrightness: CGFloat = 0.0
    
    /// The maximum brightness value allowed.
    let maxBrightness: CGFloat = 254.0
    
    
    // MARK: - Public Variables
    
    /// The bridge the app is connected to.
    var connectedBridge: PHBridgeConfiguration? {
        return PHBridgeResourcesReader.readBridgeResourcesCache().bridgeConfiguration
    }
        
    
    // MARK: - Private Variables
    
    /// The Philips Hue SDK instance.
    private var hueSDK: PHHueSDK?
    
    /// The search object that tries to discover bridges.
    private var bridgeSearch: PHBridgeSearching?
    
    // MARK: - Initialization
    
    private override init()
    {
        super.init()
        
        // Create the SDK instance
        self.hueSDK = PHHueSDK()
        self.hueSDK?.startUpSDK()
        
        #if DEBUG
            self.hueSDK?.enableLogging(true)
        #endif
    }
    
    
    // MARK: - Notifications
    
    func registerObject(object: AnyObject, withSelector selector: Selector, forNotificationName notification: String)
    {
        PHNotificationManager.defaultManager().registerObject(object, withSelector: selector, forNotification: notification)
    }
    
    func deregisterObjectForAllNotifications(object: AnyObject)
    {
        PHNotificationManager.defaultManager().deregisterObjectForAllNotifications(object)
    }

    
    // MARK: - Bridge Discovery
    
    /**
     This method starts the local heartbeat.
     It checks if we are already connected to a bridge.
     */
    func enableLocalHeartbeat()
    {
        // Check if we are already connected to a bridge
        if (self.connectedBridge != nil)
        {
            // Enable the heartbeat
            self.hueSDK?.enableLocalConnection()
        }
    }
    
    /**
     This method stops the local heartbeat.
     */
    func disableLocalHeartbeat()
    {
        self.hueSDK?.disableLocalConnection()
    }
    
    /**
     This method searches for a bridge locally.
     */
    func searchForLocalBridge(completion: (bridge: HueBridge?) -> Void)
    {
        // Stop the heartbeat
        self.disableLocalHeartbeat()
        
        // Configure the search
        self.bridgeSearch = PHBridgeSearching(upnpSearch: true, andPortalSearch: true, andIpAdressSearch: true)
        
        // Start the search
        self.bridgeSearch?.startSearchWithCompletionHandler({ (bridgesFound) in
            
            // The search is complete, check if we found a bridge
            MWLog("\(bridgesFound.count) BRIDGES FOUND: \(bridgesFound)")
            
            // DEBUG, use the first object
            if let bridge = bridgesFound.first, id = bridge.0 as? String, ip = bridge.1 as? String
            {
                self.hueSDK?.setBridgeToUseWithId(id, ipAddress: ip)
                self.hueSDK?.enableLocalConnection()
                completion(bridge: HueBridge(id: id, ip: ip))
            }
            else
            {
                completion(bridge: nil)
            }
        
        })
    }
    
    /**
     This method cancels the bridge search and deinitializes the instance.
     */
    func cancelBridgeSearch()
    {
        self.bridgeSearch?.cancelSearch()
        self.bridgeSearch = nil
    }
    
    
    // MARK: - Bridge Connection
    
    /**
     This method starts the push link authentication. After being called,
     there is a 30 second window for a bridge's link button to be pushed.
     */
    func startPushLinkAuthentication()
    {
        self.hueSDK?.startPushlinkAuthentication()
    }
    
    
    // MARK: - Controlling Lights
    
    /**
     This mehtod loops through the lights on the connected bridge and 
     randomizes their colors. If a the state of a light is off, it will
     be ignored.
     */
    func randomizeAllLights()
    {
        let api = PHBridgeSendAPI()

        // Loop through the lights
        for light in PHBridgeResourcesReader.readBridgeResourcesCache().lights.values
        {
            // If the light is off, don't randomize its color
            guard let state = light.lightState where state.on == 1 else
            {
                continue
            }

            // Create a random light state
            let lightState = PHLightState()
            lightState.hue = NSNumber(integer: Int(arc4random()) % Int(self.maxHue))
            lightState.brightness = NSNumber(integer: Int(self.maxBrightness))
            lightState.saturation = NSNumber(integer: Int(self.maxSaturation))
            
            // Send the API request to set the new light color
            api.updateLightStateForId(light.identifier,
                withLightState: lightState,
                completionHandler: { (errors) in
                    if (errors != nil)
                    {
                        MWLog("Error changing \(light.name ?? "light"): \(errors)")
                    }
            })
        }
    }
    
    
    // MARK: - Instance Methods
    
    /**
     This method converts a UIColor to the HSB color space: Hue, Saturation, Brightness.
     
     - parameter color: the UIColor object to convert to a HueColor
     
     - returns: the HueColor if the UIColor could be represented in the HSB color space, nil otherwise
     */
    func getHueColor(fromColor color: UIColor) -> HueColor?
    {
        // Reference the color components
        var hue: CGFloat        = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat      = 0.0
        
        // Make sure the RGB color can be converted to the HSB color space
        if (color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha))
        {
            // Transform the values to the format the Hue lights need
            hue        *= self.maxHue
            saturation *= self.maxSaturation
            brightness *= self.maxBrightness
            
            // Return the HueColor structure
            return HueColor(hue: hue, saturation: saturation, brightness: brightness)
        }
        
        // Couldn't convert the color
        return nil
    }
}
