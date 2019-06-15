//
//  FriendProfileProfile.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct FriendProfileProfile: Codable {
    let userId: String?
    let fullname: String?
    let memberSince: Int?
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case fullname = "fullname"
        case memberSince = "member_since"
        case photoUrl = "photo_url"
    }
}
