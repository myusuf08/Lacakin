//  
//  FriendEventsCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct FriendEventsCoordinator {
    static func createFriendEventsViewController() -> FriendEventsViewController {
        let controller = FriendEventsViewController()
        controller.viewModel = FriendEventsViewModel()
        controller.coordinator = FriendEventsCoordinator()
        return controller
    }
}

