//  
//  DetailActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 04/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct DetailActivityResponse: Codable {
    let actCheckpoints: [DetailActivityCheckpoint]?
    let actCode: String?
    let actComments: Int?
    let actCreated: Int?
    let actDateTimeEnd: Int?
    let actDateTimeStart: Int?
    let actDesc: String?
    let actId: Int?
    let actIslike: Int?
    let actJoined: Int?
    let actLatlong: String?
    let actLikes: Int?
    let actLocation: String?
    let actName: String?
    let actPublic: Int?
    let actRoutes: [DetailActivityRoute]?
    let actTimezone: String?
    let actsetGpsInterval: Int?
    let actJoinApproval: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case actCheckpoints = "act_checkpoints"
        case actCode = "act_code"
        case actComments = "act_comments"
        case actCreated = "act_created"
        case actDateTimeEnd = "act_date_time_end"
        case actDateTimeStart = "act_date_time_start"
        case actDesc = "act_desc"
        case actId = "act_id"
        case actIslike = "act_islike"
        case actJoined = "act_joined"
        case actLatlong = "act_latlong"
        case actLikes = "act_likes"
        case actLocation = "act_location"
        case actName = "act_name"
        case actPublic = "act_public"
        case actRoutes = "act_routes"
        case actTimezone = "act_timezone"
        case actsetGpsInterval = "actset_gps_interval"
        case actJoinApproval = "act_join_approval"
    }
}
