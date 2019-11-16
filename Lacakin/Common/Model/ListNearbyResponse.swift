//  
//  ListNearbyResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ListNearbyResponse: Codable {
    let userid: String?
    let name: String?
    let photo: String?
    let act: String?
    let la: String?
    let lo: String?
    let al: Int?
    let co: Int?
    let sp: Int?
    let bat: Int?
    let tz: String?
    let tm: String?
    let dist: Int?
    let phone: String?
}
