//  
//  ListGroupChatData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ListGroupChatData: Codable {
    let message: String?
    let status: Int?
    let data: [ListGroupChatResponse]?
}

