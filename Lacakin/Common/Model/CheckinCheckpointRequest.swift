//  
//  CheckinCheckpointRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct CheckinCheckpointRequest: Codable {
    let cpid: Int?
    let actcode: String?
    let lat: String?
    let long: String?
    let tz: String?
    let tm: Int?
}

