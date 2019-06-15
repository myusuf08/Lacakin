//
//  SocialProfile.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct SocialProfile: Codable, DefaultsSerializable {
    let name: String?
    let socialMediaType: String?
    let email: String?
    let id: String?
    let profilePicture: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case socialMediaType = "social_media_type"
        case email
        case id
        case profilePicture = "profile_picture"
        case token
    }
}
