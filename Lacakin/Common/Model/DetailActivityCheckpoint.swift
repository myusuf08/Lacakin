//
//  DetailActivityCheckpoint.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailActivityCheckpoint: Codable {
    let actcpDate: Int?
    let actcpDesc: String?
    let actcpIcon: String?
    let actcpId: Int?
    let actcpName: String?
    let actcpPoint: String?
    let actcpRadius: Int?
    
    enum CodingKeys: String, CodingKey {
        case actcpDate = "actcp_date"
        case actcpDesc = "actcp_desc"
        case actcpIcon = "actcp_icon"
        case actcpId = "actcp_id"
        case actcpName = "actcp_name"
        case actcpPoint = "actcp_point"
        case actcpRadius = "actcp_radius"
        
    }
}
