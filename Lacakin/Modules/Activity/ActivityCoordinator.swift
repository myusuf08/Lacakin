//  
//  ActivityCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ActivityCoordinator {
    static func createActivityViewController(isEdit: Bool = false, idActivity: String = "") -> ActivityViewController {
        let controller = ActivityViewController()
        controller.viewModel = ActivityViewModel(isEdit: isEdit, idActivity: idActivity)
        controller.coordinator = ActivityCoordinator()
        return controller
    }
}

