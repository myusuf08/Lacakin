//  
//  DetailEventCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailEventCoordinator {
    static func createDetailEventViewController(eventId: String) -> DetailEventViewController {
        let controller = DetailEventViewController()
        controller.viewModel = DetailEventViewModel(eventId: eventId)
        controller.coordinator = DetailEventCoordinator()
        return controller
    }
}

