//
//  EditActivityRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct EditActivityRequest: Codable {
    let actName: String?
    let actDesc: String?
    let actDateTimeStart: String?
    let actLocation: String?
    let actLatlong: String?
    let actTimezone: String?
    let actPublic: String?
    let actJoinApproval: String?
    let actId: String?
    
    enum CodingKeys: String, CodingKey {
        case actName = "act_name"
        case actDesc = "act_desc"
        case actDateTimeStart = "act_date_time_start"
        case actLocation = "act_location"
        case actLatlong = "act_latlong"
        case actTimezone = "act_timezone"
        case actPublic = "act_public"
        case actJoinApproval = "act_join_approval"
        case actId = "act_id"
    }
}
