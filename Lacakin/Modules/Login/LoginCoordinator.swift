//  
//  LoginCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct LoginCoordinator {
    static func createLoginViewController() -> LoginViewController {
        let controller = LoginViewController()
        controller.viewModel = LoginViewModel()
        controller.coordinator = LoginCoordinator()
        return controller
    }
}

