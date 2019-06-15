//
//  RegisterResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 15/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct RegisterResponse: Codable {
    let phone: String?
    let verified: Int?
    let token: String?
}

