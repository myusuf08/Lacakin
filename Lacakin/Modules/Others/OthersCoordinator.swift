//  
//  OthersCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct OthersCoordinator {
    static func createOthersViewController() -> OthersViewController {
        let controller = OthersViewController()
        controller.viewModel = OthersViewModel()
        controller.coordinator = OthersCoordinator()
        return controller
    }
}

