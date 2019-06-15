//
//  UIViewController+UIBarButtonItem.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addLeftBackButton(_ selector: Selector) {
        addLeftBarButtonItem(
            image: ImageConstant.backLeftArrowIcon,
            tintColor: .almostBlack,
            selector: selector)
    }
    
    func addEmptyBarButton(isRight: Bool) {
        navigationItem.rightBarButtonItem = nil
        let empty = addEmptyBarButtonItem()
        addMultipleBarButtonItem([empty], isRight: isRight)
    }
    
    func addBarButtonSave(_ selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 20)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = UIFont.defaultBoldFont(size: 14)
        button.setTitleColor(.black, for: .normal)
        return addBarButtonItemCustomView(view: button)
    }
    
    func addBarButtonAdd(_ selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.bounds = CGRect(x: 0, y: 0, width: 40, height: 20)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setTitle("ADD", for: .normal)
        button.titleLabel?.font = UIFont.defaultBoldFont(size: 14)
        button.setTitleColor(.black, for: .normal)
        return addBarButtonItemCustomView(view: button)
    }
    
    func addBarButtonMore(_ selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.setBackgroundImage(UIImage(named: "ic_dots-vertical"), for: .normal)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = UIFont.defaultBoldFont(size: 14)
        button.setTitleColor(.black, for: .normal)
        return addBarButtonItemCustomView(view: button)
    }
    
    func addRightBarButtonSave(_ selector: Selector) {
        let cancel = addBarButtonSave(selector)
        addRightBarButtonItem(cancel, tintColor: .almostBlack)
    }
    
    func addRightBarButtonAdd(_ selector: Selector) {
        let cancel = addBarButtonAdd(selector)
        addRightBarButtonItem(cancel, tintColor: .almostBlack)
    }
    
    func addRightBarButtonMore(_ selector: Selector) {
        navigationItem.rightBarButtonItem = nil
        let cancel = addBarButtonMore(selector)
        addRightBarButtonItem(cancel, tintColor: .almostBlack)
    }
}
