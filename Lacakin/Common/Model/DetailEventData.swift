//  
//  DetailEventData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailEventData: Codable {
    let message: String?
    let status: Int?
    let data: DetailEventResponse
}

