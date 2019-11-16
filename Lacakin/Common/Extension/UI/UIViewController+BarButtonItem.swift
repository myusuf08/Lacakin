//
//  UIViewController+BarButtonItem.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import UIKit

extension UIViewController {
    func addLeftBarButtonItem(image: UIImage, tintColor: UIColor, selector: Selector) {
        let barButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: selector)
        addLeftBarButtonItem(barButtonItem, tintColor: tintColor)
    }
    
    func addBarButtonItemCustomView(view: UIView) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(customView: view)
        return barButtonItem
    }
    
    func addEmptyBarButtonItem() -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(),
            style: .plain,
            target: self,
            action: nil)
        return barButtonItem
    }
}


extension UIViewController {
    func addRightBarButtonItem(_ item: UIBarButtonItem, tintColor: UIColor) {
        item.tintColor = tintColor
        guard let items = navigationItem.rightBarButtonItems, items.count > 0 else {
            navigationItem.rightBarButtonItem = item
            return
        }
        navigationItem.rightBarButtonItems?.append(item)
    }
    
    func addLeftBarButtonItem(_ item: UIBarButtonItem, tintColor: UIColor) {
        item.tintColor = tintColor
        guard let items = navigationItem.leftBarButtonItems, items.count > 0 else {
            navigationItem.leftBarButtonItem = item
            return
        }
        navigationItem.leftBarButtonItems?.append(item)
    }
    
    func addMultipleBarButtonItem(_ item: [UIBarButtonItem],isRight: Bool = true) {
        if isRight {
            navigationItem.rightBarButtonItems = item
        } else {
            navigationItem.leftBarButtonItems = item
        }
    }
}
