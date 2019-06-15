//
//  LoginData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 12/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct LoginData: Codable {
    let message: String?
    let status: Int?
    let data: Profile//LoginResponse
}
