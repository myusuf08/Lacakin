//
//  ActivityListResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ActivityListResponse: Codable {
    let actId: Int?
    let actCode: String?
    let actName: String?
    let actDesc: String?
    let actDateTimeStart: Int?
    let actTimezone: String?
    let actPublic: Int?
    let actCreated: Int?
    let actComments: Int?
    let actUserid: Int?
    let actLikes: Int?
    let actIslike: String?
    let actLocation: String?
    let photos: [ActivityListPhoto]?
    
    enum CodingKeys: String, CodingKey {
        case actId = "act_id"
        case actCode = "act_code"
        case actName = "act_name"
        case actDesc = "act_desc"
        case actDateTimeStart = "act_date_time_start"
        case actTimezone = "act_timezone"
        case actPublic = "act_public"
        case actCreated = "act_created"
        case actComments = "act_comments"
        case actUserid = "act_userid"
        case actLocation = "act_location"
        case actLikes = "act_likes"
        case actIslike = "act_islike"
        case photos = "photos"
        
    }
}

