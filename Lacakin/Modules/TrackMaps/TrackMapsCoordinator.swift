//  
//  TrackMapsCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 03/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct TrackMapsCoordinator {
    static func createTrackMapsViewController(code: String) -> TrackMapsViewController {
        let controller = TrackMapsViewController()
        controller.viewModel = TrackMapsViewModel(code: code)
        controller.coordinator = TrackMapsCoordinator()
        return controller
    }
}

