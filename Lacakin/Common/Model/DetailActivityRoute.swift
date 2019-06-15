//
//  DetailActivityRoute.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct DetailActivityRoute: Codable {
    let actruteColor: String?
    let actruteData: String?
    let actruteDesc: String?
    let actruteDist: Int?
    let actruteElevgain: Int?
    let actruteEncode: Int?
    let actruteName: String?
    
    enum CodingKeys: String, CodingKey {
        case actruteColor = "actrute_color"
        case actruteData = "actrute_data"
        case actruteDesc = "actrute_desc"
        case actruteDist = "actrute_dist"
        case actruteElevgain = "actrute_elevgain"
        case actruteEncode = "actrute_encode"
        case actruteName = "actrute_name"
        
    }
}
