//  
//  SetEmailData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct SetEmailData: Codable {
    let message: String?
    let status: Int?
    let data: SetEmailResponse
}

