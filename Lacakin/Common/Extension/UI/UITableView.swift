//
//  UITableView.swift
//  CIRCL
//
//  Created by Muhammad Yusuf on 04/12/18.
//  Copyright © 2018 Circl.It. All rights reserved.
//

import UIKit

protocol ReusableView {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableView {
    
    func registerNib<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerClass<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerHeaderFooter<T: UIView>(_: T.Type) where T: ReusableView {
        let nib = UINib(nibName: T.reuseIdentifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueClass<T: UITableViewCell>(_ class: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.nibName) as! T
    }
    
    func dequeueClassAtRow<T: UITableViewCell>(_ class: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as! T
    }
    
    func dequeueCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath)
        -> T where T: ReusableView {
            return dequeueReusableCell(
                withIdentifier: T.reuseIdentifier,
                for: indexPath) as! T
    }
    
    func showEmptyLabel(text: String){
        let screenSize = UIScreen.main.bounds
        let x = (screenSize.size.width/2) - 50
        let y = (screenSize.size.height/2) - 7
        let lbEmptyText = UILabel(frame: CGRect(x: x,
                                                y: y,
                                                width: 100,
                                                height: 14))
        let frameEmptyLabel = UIView()
        frameEmptyLabel.addSubview(lbEmptyText)
        lbEmptyText.text = text
        lbEmptyText.textAlignment = .center
        lbEmptyText.textColor = UIColor.lightGray
        lbEmptyText.font = UIFont.systemFont(ofSize: 11)
        lbEmptyText.sizeToFit()
        backgroundView = frameEmptyLabel
        lbEmptyText.frame.origin.y = 16
        lbEmptyText.center.x = frameEmptyLabel.center.x
        layoutIfNeeded()
    }
    
    func removeEmptyLabel(){
        if backgroundView != nil {
            backgroundView!.removeFromSuperview()
        }
    }
}
