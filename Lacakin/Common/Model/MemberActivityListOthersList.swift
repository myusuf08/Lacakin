//
//  MemberActivityListOthersList.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct MemberActivityListOthersList: Codable {
    let memId: Int?
    let memUserid: Int?
    let userId: String?
    let memName: String?
    let memDate: Int?
    let memHide: Int?
    let memPhoto: String?
    
    
    enum CodingKeys: String, CodingKey {
        case memId = "mem_id"
        case memUserid = "mem_userid"
        case userId = "user_id"
        case memName = "mem_name"
        case memDate = "mem_date"
        case memHide = "mem_hide"
        case memPhoto = "mem_photo"
    }
}
