//  
//  ActivityListOthersResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ActivityListOthersResponse: Codable {
    let actId: Int?
    let actCode: String?
    let actName: String?
    let actDesc: String?
    let actDateTimeStart: Int?
    let actTimezone: String?
    let actCreated: Int?
    let actComments: Int?
    let actUserid: Int?
    let actLikes: Int?
    let actIslike: String?
    let actmemActive: Int?
    let actmemDate: Int?
    let ownerId: String?
    let ownerName: String?
    let ownerPhoto: String?
    let photos: [ActivityListPhoto]?
    
    enum CodingKeys: String, CodingKey {
        case actId = "act_id"
        case actCode = "act_code"
        case actName = "act_name"
        case actDesc = "act_desc"
        case actDateTimeStart = "act_date_time_start"
        case actTimezone = "act_timezone"
        case actCreated = "act_created"
        case actComments = "act_comments"
        case actUserid = "act_userid"
        case actLikes = "act_likes"
        case actIslike = "act_islike"
        case actmemActive = "actmem_active"
        case actmemDate = "actmem_date"
        case ownerId = "owner_id"
        case ownerName = "owner_name"
        case ownerPhoto = "owner_photo"
        case photos = "photos"
        
    }
}
