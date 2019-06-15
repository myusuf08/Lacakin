//
//  LoginResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 07/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct LoginResponse: Codable { // UN USE COZ PROFILE CLASS NEED IT
    let userId: String?
//    let username: String?
//    let email: String?
    let fullname: String?
    let phone: String?
//    let sex: String?
//    let birth: String?
//    let bio: String?
//    let memberSince: Int?
    let passwordSet: String?
    let verified: Int?
    let verifiedEmail: Int?
    let photoUrl: String?
    let tz: String?
    let unit: String?
    //let lang: String?
    let token: String?
    let status: Bool?   
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
////        username = try values.decodeIfPresent(String.self, forKey: .username)
////        email = try values.decodeIfPresent(String.self, forKey: .email)
//        fullname = try values.decodeIfPresent(String.self, forKey: .fullname)
//        phone = try values.decodeIfPresent(String.self, forKey: .phone)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//        userId = try values.decodeIfPresent(String.self, forKey: .userId)
//    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
//        case username
//        case email
        case fullname
        case phone
//        case sex
//        case birth
//        case bio
//        case memberSince = "member_since"
        case passwordSet = "password_set"
        case verified
        case verifiedEmail = "verified_email"
        case photoUrl = "photo_url"
        case tz
        case unit
//        case lang
        case token
        case status
    }
}
