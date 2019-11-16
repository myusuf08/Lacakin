//  
//  HomeCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct HomeCoordinator {
    static func createHomeViewController() -> HomeViewController {
        let controller = HomeViewController()
        controller.viewModel = HomeViewModel()
        controller.coordinator = HomeCoordinator()
        return controller
    }
}

