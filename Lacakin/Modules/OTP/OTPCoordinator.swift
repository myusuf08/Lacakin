//  
//  OTPCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct OTPCoordinator {
    static func createOTPViewController(phone: String, isOTPChangePhone: Bool = false) -> OTPViewController {
        let controller = OTPViewController()
        controller.viewModel = OTPViewModel(phone: phone, isOTPChangePhone: isOTPChangePhone)
        controller.coordinator = OTPCoordinator()
        return controller
    }
}

