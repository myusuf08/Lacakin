//  
//  FriendActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct FriendActivityResponse: Codable {
    let actId: Int?
    let ownerId: String?
    let ownerName: String?
    let actCode: String?
    let actName: String?
    let actDesc: String?
    let actTimestamp: Int?
    let flag: String?
    let photos: [ActivityPhotoData]?
    
    enum CodingKeys: String, CodingKey {
        case actId = "act_id"
        case ownerId = "owner_id"
        case ownerName = "owner_name"
        case actCode = "act_code"
        case actName = "act_name"
        case actDesc = "act_desc"
        case actTimestamp = "act_timestamp"
        case flag = "flag"
        case photos = "photos"
        
    }
}
