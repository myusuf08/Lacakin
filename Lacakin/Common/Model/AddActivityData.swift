//
//  AddActivityData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AddActivityData: Codable {
    let message: String?
    let status: Int?
    let data: AddActivityResponse
}
