//  
//  NearbyCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct NearbyCoordinator {
    static func createNearbyViewController(code: String) -> NearbyViewController {
        let controller = NearbyViewController()
        controller.viewModel = NearbyViewModel(code: code)
        controller.coordinator = NearbyCoordinator()
        return controller
    }
}

