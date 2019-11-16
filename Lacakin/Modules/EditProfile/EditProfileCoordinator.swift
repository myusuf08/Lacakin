//  
//  EditProfileCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EditProfileCoordinator {
    static func createEditProfileViewController() -> EditProfileViewController {
        let controller = EditProfileViewController()
        controller.viewModel = EditProfileViewModel()
        controller.coordinator = EditProfileCoordinator()
        return controller
    }
}

