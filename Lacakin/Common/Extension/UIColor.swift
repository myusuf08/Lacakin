//
//  UIColor+Extension.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import UIKit

extension UIColor {
    static var almostBlack: UIColor {
        return UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    }
    
    static var collectionViewBackground: UIColor {
        return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    }
    
    static var defaultBlue: UIColor {
        return UIColor(red: 0.0/255.0,
                       green: 182.0/255,
                       blue: 236.0/255.0, alpha: 1)
    }
    
    static var bluePath: UIColor {
        return UIColor(red: 0.0/255.0,
                       green: 122.0/255,
                       blue: 255.0/255.0, alpha: 1)
    }
    
    static var defaultRed: UIColor {
        return UIColor(red: 238.0/255.0,
                       green: 65.0/255,
                       blue: 123.0/255.0, alpha: 1)
    }
    
    static var shadowBold: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }
    
    class var transparantShadow: UIColor {
        return UIColor.black.withAlphaComponent(0.15)
    }
}
