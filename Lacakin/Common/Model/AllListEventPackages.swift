//
//  AllListEventPackages.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AllListEventPackages: Codable {
    let packageId: Int?
    let packageName: String?
    let packageDesc: String?
    let packagePrice: Int?
    let packageQuota: Int?
    
    enum CodingKeys: String, CodingKey {
        case packageId = "package_id"
        case packageName = "package_name"
        case packageDesc = "package_desc"
        case packagePrice = "package_price"
        case packageQuota = "package_quota"
    }
    
}
