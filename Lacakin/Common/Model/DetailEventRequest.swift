//  
//  DetailEventRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct DetailEventRequest: Codable {
    let eventId: String?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
    }
}

