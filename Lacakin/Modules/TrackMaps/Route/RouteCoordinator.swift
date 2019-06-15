//  
//  RouteCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct RouteCoordinator {
    static func createRouteViewController(code: String) -> RouteViewController {
        let controller = RouteViewController()
        controller.viewModel = RouteViewModel(code: code)
        controller.coordinator = RouteCoordinator()
        return controller
    }
}

