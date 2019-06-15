//  
//  ListNearbyRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct ListNearbyRequest: Codable {
    let code: String?
    let lat: String?
    let long: String?
}

