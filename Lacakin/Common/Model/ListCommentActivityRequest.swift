//  
//  ListCommentActivityRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct ListCommentActivityRequest: Codable {
    let actid: Int?
    let actcode: String?
    let page: Int?
    let view: Int?
    
}

