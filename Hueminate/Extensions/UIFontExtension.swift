//
//  UIFontExtension.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

enum FontWeight {
    case Bold
    case DemiBold
    case Medium
    case Regular
    case Light
    case Italic
    
    var name: String {
        switch (self) {
        case .Bold:
            return "AvenirNext-Bold"
        case .DemiBold:
            return "AvenirNext-DemiBold"
        case .Medium:
            return "AvenirNext-Medium"
        case .Regular:
            return "AvenirNext-Regular"
        case .Light:
            return "AvenirNext-UltraLight"
        case .Italic:
            return "AvenirNext-Italic"
        }
    }
}

extension UIFont {
    
    // MARK: - Static Fonts
    
    class var navigationBarFont: UIFont {
        return self.fontOfSize(20.0, weight: FontWeight.Regular)
    }
    
    class func fontOfSize(size: CGFloat, weight: FontWeight) -> UIFont {
        return self.init(name: weight.name, size: size)!
    }
    
    
    // MARK: - Dynamic Fonts
    
    class func fontForTextStyle(style: String, weight: FontWeight) -> UIFont {
        let font = self.preferredFontForTextStyle(style)
        return self.fontOfSize(font.pointSize, weight: weight)
    }
}
