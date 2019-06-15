//  
//  CheckpointCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct CheckpointCoordinator {
    static func createCheckpointViewController(code: String) -> CheckpointViewController {
        let controller = CheckpointViewController()
        controller.viewModel = CheckpointViewModel(code: code)
        controller.coordinator = CheckpointCoordinator()
        return controller
    }
}

