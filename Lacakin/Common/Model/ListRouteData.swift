//  
//  ListRouteData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ListRouteData: Codable {
    let message: String?
    let status: Int?
    let data: [ListRouteResponse]?
}

