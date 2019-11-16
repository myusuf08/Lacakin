//  
//  AllListEventData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AllListEventData: Codable {
    let message: String?
    let status: Int?
    let data: [AllListEventResponse]?
}

