//  
//  TrackChatCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct TrackChatCoordinator {
    static func createTrackChatViewController(code: String) -> TrackChatViewController {
        let controller = TrackChatViewController()
        controller.viewModel = TrackChatViewModel(code: code)
        controller.coordinator = TrackChatCoordinator()
        return controller
    }
}

