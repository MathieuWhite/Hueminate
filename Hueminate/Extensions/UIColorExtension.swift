//
//  UIColorExtension.swift
//  Hueminate
//
//  Created by Mathieu White on 2016-04-30.
//  Copyright © 2016 Mathieu White. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Background Colors
    
    class var lightGray: UIColor {
        return self.init(red: 243.0/255.0, green: 246.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    
    // MARK: - Text Colors
    
    class var gray: UIColor {
        return self.init(red: 179.0/255.0, green: 182.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    }
    
    class var darkGray: UIColor {
        return self.init(red: 40.0/255.0, green: 43.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    }
    
    
    // MARK: - Custom Colors
    
    class var red: UIColor {
        return self.init(red: 249.0/255.0, green: 57.0/255.0, blue: 57.0/255.0, alpha: 1.0)
    }
    
    class var green: UIColor {
        return self.init(red: 12.0/255.0, green: 172.0/255.0, blue: 108.0/255.0, alpha: 1.0)
    }
    
    class var blue: UIColor {
        return self.init(red: 42.0/255.0, green: 122.0/255.0, blue: 218.0/255.0, alpha: 1.0)
    }
    
    
    // MARK: - White and Black Colors
    
    class func whiteColorWithAlpha(alpha: CGFloat) -> UIColor {
        return self.init(white: 1.0, alpha: alpha)
    }
    
    class func blackColorWithAlpha(alpha: CGFloat) -> UIColor {
        return self.init(white: 0.0, alpha: alpha)
    }
}
