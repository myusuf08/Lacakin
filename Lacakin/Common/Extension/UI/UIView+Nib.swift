//
//  UIView+Nib.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import UIKit

extension UIView {
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    func loadNib() {
        if let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self)?.first as? UIView {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leftAnchor.constraint(equalTo: leftAnchor),
                view.rightAnchor.constraint(equalTo: rightAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
    }
    
    class func fromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T
    }
}
