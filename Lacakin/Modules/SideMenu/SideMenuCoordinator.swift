//  
//  SideMenuCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct SideMenuCoordinator {
    static func createSideMenuViewController() -> SideMenuViewController {
        let controller = SideMenuViewController()
        controller.viewModel = SideMenuViewModel()
        controller.coordinator = SideMenuCoordinator()
        return controller
    }
}

