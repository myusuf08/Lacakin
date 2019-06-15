//  
//  ForgotPasswordCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ForgotPasswordCoordinator {
    static func createForgotPasswordViewController() -> ForgotPasswordViewController {
        let controller = ForgotPasswordViewController()
        controller.viewModel = ForgotPasswordViewModel()
        controller.coordinator = ForgotPasswordCoordinator()
        return controller
    }
}

