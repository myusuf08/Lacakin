//  
//  SearchEventsCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct SearchEventsCoordinator {
    static func createSearchEventsViewController(keyword: String) -> SearchEventsViewController {
        let controller = SearchEventsViewController()
        controller.viewModel = SearchEventsViewModel(keyword: keyword)
        controller.coordinator = SearchEventsCoordinator()
        return controller
    }
}

