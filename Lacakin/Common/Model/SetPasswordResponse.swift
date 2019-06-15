//  
//  SetPasswordResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct SetPasswordResponse: Codable {
    let status: Bool?
    let token: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}
