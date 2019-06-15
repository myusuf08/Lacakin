//  
//  StandartCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct StandartCoordinator {
    static func createStandartViewController(title: String) -> StandartViewController {
        let controller = StandartViewController()
        controller.viewModel = StandartViewModel(title: title)
        controller.coordinator = StandartCoordinator()
        return controller
    }
}

