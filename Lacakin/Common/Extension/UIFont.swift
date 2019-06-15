//
//  UIFont.swift
//  CIRCL
//
//  Created by Muhammad Yusuf on 03/12/18.
//  Copyright © 2018 Circl.It. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func defaultFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Regular", size: size)!
    }
    
    static func defaultBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Metropolis-Bold", size: size)!
    }
    
    static func regular() -> UIFont {
        return UIFont(name: "Metropolis-Regular", size: 13)!
    }
}
