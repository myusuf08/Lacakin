//
//  ActivityListPhoto.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ActivityListPhoto: Codable {
    let actphoId: Int?
    let actphoPhotourl: String?
    let actphoTitle: String?
    let actphoDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case actphoId = "actpho_id"
        case actphoPhotourl = "actpho_photourl"
        case actphoTitle = "actpho_title"
        case actphoDate = "actpho_date"
        
    }
}
