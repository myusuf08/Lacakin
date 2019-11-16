//  
//  AllListEventRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct AllListEventRequest: Codable {
    let offset: Int?
    let limit: Int?
    let keyword: String?
    let location: String?
    let startDate: String?
    let endDate: String?
    let minPrice: Int?
    let maxPrice: Int?
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case keyword
        case location
        case startDate = "start_date"
        case endDate = "end_date"
        case minPrice = "min_price"
        case maxPrice = "max_price"
    }
}

