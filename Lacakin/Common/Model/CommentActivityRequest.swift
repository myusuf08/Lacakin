//  
//  CommentActivityRequest.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

public struct CommentActivityRequest: Codable {
    let actid: String?
    let actcode: String?
//    let replyid: String?
    let text: String?
}

