//  
//  GetProfileResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct GetProfileResponse: Codable {
    let test: Int?
    
    enum CodingKeys: String, CodingKey {
        case test = "test"
        
    }
}
