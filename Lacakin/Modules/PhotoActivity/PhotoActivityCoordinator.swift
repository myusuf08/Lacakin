//  
//  PhotoActivityCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct PhotoActivityCoordinator {
    static func createPhotoActivityViewController(isMemberValid: Bool, actId: String, model: [ListPhotoActivityResponse]?) -> PhotoActivityViewController {
        let controller = PhotoActivityViewController()
        controller.isMemberValid = isMemberValid
        controller.viewModel = PhotoActivityViewModel(actId: actId, model: model)
        controller.coordinator = PhotoActivityCoordinator()
        return controller
    }
}

