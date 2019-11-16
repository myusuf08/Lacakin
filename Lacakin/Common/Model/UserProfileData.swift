//  
//  UserProfileData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct UserProfileData: Codable {
    let message: String?
    let status: Int?
    let data: UserProfileResponse
}

