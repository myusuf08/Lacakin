//  
//  ApproveMemberActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ApproveMemberActivityResponse: Codable {
    let test: Int?
    
    enum CodingKeys: String, CodingKey {
        case test = "test"
        
    }
}
