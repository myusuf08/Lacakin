//  
//  DetailActivityData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 04/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailActivityData: Codable {
    let message: String?
    let status: Int?
    let data: DetailActivityResponse
}

