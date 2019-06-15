//  
//  RegisterCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct RegisterCoordinator {
    static func createRegisterViewController() -> RegisterViewController {
        let controller = RegisterViewController()
        controller.viewModel = RegisterViewModel()
        controller.coordinator = RegisterCoordinator()
        return controller
    }
}

