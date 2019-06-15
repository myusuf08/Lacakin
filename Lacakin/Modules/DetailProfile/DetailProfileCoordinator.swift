//  
//  DetailProfileCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailProfileCoordinator {
    static func createDetailProfileViewController(friendId: String, isUser: Bool) -> DetailProfileViewController {
        let controller = DetailProfileViewController()
        controller.viewModel = DetailProfileViewModel(friendId: friendId, isUser: isUser)
        controller.coordinator = DetailProfileCoordinator()
        return controller
    }
}

