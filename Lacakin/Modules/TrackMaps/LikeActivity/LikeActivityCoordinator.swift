//  
//  LikeActivityCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct LikeActivityCoordinator {
    static func createLikeActivityViewController(actId: String, actCode: String) -> LikeActivityViewController {
        let controller = LikeActivityViewController()
        controller.viewModel = LikeActivityViewModel(actId: actId, actCode: actId)
        controller.coordinator = LikeActivityCoordinator()
        return controller
    }
}

