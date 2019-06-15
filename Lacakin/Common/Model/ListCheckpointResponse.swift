//  
//  ListCheckpointResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ListCheckpointResponse: Codable {
    let actcpId: Int?
    let actcpName: String?
    let actcpDesc: String?
    let actcpPoint: String?
    let actcpIcon: String?
    let actcpRadius: Int?
    let actcpDate: Int?
    let numCheckin: Int?
    let isCheckin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case actcpId = "actcp_id"
        case actcpName = "actcp_name"
        case actcpDesc = "actcp_desc"
        case actcpPoint = "actcp_point"
        case actcpIcon = "actcp_icon"
        case actcpRadius = "actcp_radius"
        case actcpDate = "actcp_date"
        case numCheckin = "num_checkin"
        case isCheckin = "is_checkin"
        
    }
}
