//
//  Profile.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct Profile: Codable, DefaultsSerializable {
    var userId: String?
    var username: String?
    var email: String?
    var fullname: String?
    var phone: String?
    var sex: String?
    var birth: Int?
    var bio: String?
    //    let memberSince: Int? unwrap json
    var passwordSet: String?
    var verified: Int?
    var verifiedEmail: Int?
    var photoUrl: String?
    var tz: String?
    var unit: String?
    var lang: String?
    var token: String?
    var status: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case username
        case email
        case fullname
        case phone
        case sex
        case birth
        case bio
        // case memberSince = "member_since" unwrap json
        case passwordSet = "password_set"
        case verified
        case verifiedEmail = "verified_email"
        case photoUrl = "photo_url"
        case tz
        case unit
        case lang
        case token
        case status
    }
}
