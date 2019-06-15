//  
//  CommentCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct CommentCoordinator {
    static func createCommentViewController(actCode: String, actId: String) -> CommentViewController {
        let controller = CommentViewController()
        controller.viewModel = CommentViewModel(actCode: actCode, actId: actId)
        controller.coordinator = CommentCoordinator()
        return controller
    }
}

