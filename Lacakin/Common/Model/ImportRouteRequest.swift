//  
//  ImportRouteRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 28/05/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct ImportRouteRequest: Codable {
    let test: String?
    
    enum CodingKeys: String, CodingKey {
        case test = "test"
    }
}

