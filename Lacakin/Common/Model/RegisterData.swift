//
//  RegisterData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 15/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct RegisterData: Codable {
    let message: String?
    let status: Int?
    let data: RegisterResponse
}
