//  
//  ImportRouteResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 28/05/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ImportRouteResponse: Codable {
    let test: Int?
    
    enum CodingKeys: String, CodingKey {
        case test = "test"
        
    }
}
