//  
//  NotificationsCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct NotificationsCoordinator {
    static func createNotificationsViewController() -> NotificationsViewController {
        let controller = NotificationsViewController()
        controller.viewModel = NotificationsViewModel()
        controller.coordinator = NotificationsCoordinator()
        return controller
    }
}

