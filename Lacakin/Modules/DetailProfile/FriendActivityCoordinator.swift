//  
//  FriendActivityCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct FriendActivityCoordinator {
    static func createFriendActivityViewController(friendId: String, isUser: Bool) -> FriendActivityViewController {
        let controller = FriendActivityViewController()
        controller.viewModel = FriendActivityViewModel(friendId: friendId, isUser: isUser)
        controller.coordinator = FriendActivityCoordinator()
        return controller
    }
}

