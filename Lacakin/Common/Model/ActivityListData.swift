//
//  ActivityListData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ActivityListData: Codable {
    let message: String?
    let status: Int?
    let data: [ActivityListResponse]?
}
