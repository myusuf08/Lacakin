//  
//  EventRegisteredCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EventRegisteredCoordinator {
    static func createEventRegisteredViewController(emptyLabel: String) -> EventRegisteredViewController {
        let controller = EventRegisteredViewController()
        controller.viewModel = EventRegisteredViewModel(emptyLabel: emptyLabel)
        controller.coordinator = EventRegisteredCoordinator()
        return controller
    }
}

