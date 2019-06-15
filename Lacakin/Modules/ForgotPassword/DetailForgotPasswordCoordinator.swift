//  
//  DetailForgotPasswordCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/05/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailForgotPasswordCoordinator {
    static func createDetailForgotPasswordViewController(phone: String) -> DetailForgotPasswordViewController {
        let controller = DetailForgotPasswordViewController()
        controller.viewModel = DetailForgotPasswordViewModel(phone: phone)
        controller.coordinator = DetailForgotPasswordCoordinator()
        return controller
    }
}

