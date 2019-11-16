//
//  UIRectCorner+CACornerMask.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

extension UIRectCorner {
    
    @available(iOS 11.0, *)
    public func toCornerMask() -> CACornerMask {
        var cornerMasks: CACornerMask = []
        
        if contains(.topLeft) {
            cornerMasks.insert(.layerMinXMinYCorner)
        }
        if contains(.topRight) {
            cornerMasks.insert(.layerMaxXMinYCorner)
        }
        if contains(.bottomLeft) {
            cornerMasks.insert(.layerMinXMaxYCorner)
        }
        if contains(.bottomRight) {
            cornerMasks.insert(.layerMaxXMaxYCorner)
        }
        return cornerMasks
    }
    
}

