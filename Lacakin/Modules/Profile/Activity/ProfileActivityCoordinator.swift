//  
//  ProfileActivityCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ProfileActivityCoordinator {
    static func createProfileActivityViewController() -> ProfileActivityViewController {
        let controller = ProfileActivityViewController()
        controller.viewModel = ProfileActivityViewModel()
        controller.coordinator = ProfileActivityCoordinator()
        return controller
    }
}

