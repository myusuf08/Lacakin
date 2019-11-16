//  
//  EventThisMonthCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EventThisMonthCoordinator {
    static func createEventThisMonthViewController(emptyLabel: String) -> EventThisMonthViewController {
        let controller = EventThisMonthViewController()
        controller.viewModel = EventThisMonthViewModel(emptyLabel: emptyLabel)
        controller.coordinator = EventThisMonthCoordinator()
        return controller
    }
}

