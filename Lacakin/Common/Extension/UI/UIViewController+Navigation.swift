//
//  UIViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func replaceRootViewController(with viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.setViewControllers([viewController], animated: animated)
    }
    
}
