//  
//  DetailActivityCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 03/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailActivityCoordinator {
    static func createDetailActivityViewController(activityModel: ActivityListResponse, activityModelOthers: ActivityListOthersResponse, isFromList: Bool, joinActivityCode: String, isFromFriend: Bool) -> DetailActivityViewController {
        let controller = DetailActivityViewController()
        controller.viewModel = DetailActivityViewModel(activityModel: activityModel, activityOthersModel: activityModelOthers, isFromList: isFromList, joinActivityCode: joinActivityCode, isFromFriend: isFromFriend)
        controller.coordinator = DetailActivityCoordinator()
        return controller
    }
}

