//
//  RegisterRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 15/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct RegisterRequest: Codable {
    let name: String?
    let phone: String?
    let password: String?
    let tz: String?
}
