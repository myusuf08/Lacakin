//  
//  ProfileEventCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ProfileEventCoordinator {
    static func createProfileEventViewController() -> ProfileEventViewController {
        let controller = ProfileEventViewController()
        controller.viewModel = ProfileEventViewModel()
        controller.coordinator = ProfileEventCoordinator()
        return controller
    }
}

