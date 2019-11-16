//
//  UIView.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

extension UIView {
    public func roundCorner(radius: CGFloat = 4, clip: Bool = true, corners: UIRectCorner = []) {
        clipsToBounds = clip
        
        if corners.isEmpty {
            layer.cornerRadius = radius
        } else {
            if #available(iOS 11.0, *) {
                layer.cornerRadius = radius
                layer.maskedCorners = corners.toCornerMask()
            } else {
                let rectShape = CAShapeLayer()
                rectShape.bounds = frame
                rectShape.position = center
                rectShape.path = UIBezierPath(
                    roundedRect: bounds,
                    byRoundingCorners: corners,
                    cornerRadii: CGSize(width: radius, height: radius)).cgPath
                
                layer.mask = rectShape
            }
        }
    }
    
    public func addBorder(color: UIColor, width: CGFloat = 0.5) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func dropShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat = 15) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
    }
    
    func showBlurLoader() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        blurEffectView.contentView.addSubview(activityIndicator)
        activityIndicator.center = blurEffectView.contentView.center
        self.addSubview(blurEffectView)
    }
    
    func removeBluerLoader(){
        self.subviews.flatMap {  $0 as? UIVisualEffectView }.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func dropShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat = 15, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
