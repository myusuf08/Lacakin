//  
//  ListLikeActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ListLikeActivityResponse: Codable {
    let actlikId: Int?
    let userId: String?
    let actlikUserid: Int?
    let actlikName: String?
    let actlikPhoto: String?
    let actlikDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case actlikId = "actlik_id"
        case userId = "user_id"
        case actlikUserid = "actlik_userid"
        case actlikName = "actlik_name"
        case actlikPhoto = "actlik_photo"
        case actlikDate = "actlik_date"
    }
}
