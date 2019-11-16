//  
//  ProfileCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ProfileCoordinator {
    static func createProfileViewController() -> ProfileViewController {
        let controller = ProfileViewController()
        controller.viewModel = ProfileViewModel()
        controller.coordinator = ProfileCoordinator()
        return controller
    }
}

