//  
//  EventsCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EventsCoordinator {
    static func createEventsViewController(emptyLabel: String) -> EventsViewController {
        let controller = EventsViewController()
        controller.viewModel = EventsViewModel(emptyLabel: emptyLabel)
        controller.coordinator = EventsCoordinator()
        return controller
    }
}

