//  
//  SetPasswordRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct SetPasswordRequest: Codable {
    let oldPassword: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case password
    }
}

