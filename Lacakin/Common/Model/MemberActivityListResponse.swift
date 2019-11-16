//  
//  MemberActivityListResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct MemberActivityListResponse: Codable {
    let count: Int?
    let list: [MemberActivityListList]?
}
