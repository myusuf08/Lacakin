//  
//  RegisteredListEventRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct RegisteredListEventRequest: Codable {
    let offset: Int?
    let limit: Int?
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case userId = "user_id"
    }
    
}

