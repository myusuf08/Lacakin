//
//  UIViewController+TitleNavigation.swift
//  CIRCL
//
//  Created by Muhammad Yusuf on 06/12/18.
//  Copyright © 2018 Circl.It. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addDefaultTitleNav(title: String) {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width:
            navigationController?.navigationBar.frame.size.width ?? 0,
                             height: 21)
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.defaultBoldFont(size: 17)
        label.textColor = .black
        navigationItem.titleView = label
    }
    
}
