//  
//  LoginGoogleData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct LoginGoogleData: Codable {
    let message: String?
    let status: Int?
    let data: Profile // LoginGoogleDataResponse
}

