//  
//  ListRouteResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ListRouteResponse: Codable {
    let actruteId: Int?
    let actruteName: String?
    let actruteDesc: String?
    let actruteData: String?
    let actruteDist: Int?
    let actruteElevgain: Int?
    let actruteEncode: Int?
    let actruteColor: String?
    let actruteDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case actruteId = "actrute_id"
        case actruteName = "actrute_name"
        case actruteDesc = "actrute_desc"
        case actruteData = "actrute_data"
        case actruteDist = "actrute_dist"
        case actruteElevgain = "actrute_elevgain"
        case actruteEncode = "actrute_encode"
        case actruteColor = "actrute_color"
        case actruteDate = "actrute_date"
    }
}

