//  
//  MineCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct MineCoordinator {
    static func createMineViewController() -> MineViewController {
        let controller = MineViewController()
        controller.viewModel = MineViewModel()
        controller.coordinator = MineCoordinator()
        return controller
    }
}

