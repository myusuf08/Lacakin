//  
//  AddRouteCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AddRouteCoordinator {
    static func createAddRouteViewController(actCode: String) -> AddRouteViewController {
        let controller = AddRouteViewController()
        controller.actCode = actCode
        controller.viewModel = AddRouteViewModel()
        controller.coordinator = AddRouteCoordinator()
        return controller
    }
}

