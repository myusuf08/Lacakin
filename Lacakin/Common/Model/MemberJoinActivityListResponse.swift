//  
//  MemberJoinActivityListResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct MemberJoinActivityListResponse: Codable {
    let count: Int?
    let list: [MemberJoinActivityListList]?
    
}
