//  
//  ListCommentActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ListCommentActivityResponse: Codable {
    let actcomId: Int?
    let actcomUserid: String?
    let actcomUser: String?
    let actcomTime: Int?
    let actcomText: String?
    let haveReply: Int?
    let actcomPhoto: String?
    
    enum CodingKeys: String, CodingKey {
        case actcomId = "actcom_id"
        case actcomUserid = "actcom_userid"
        case actcomUser = "actcom_user"
        case actcomTime = "actcom_time"
        case actcomText = "actcom_text"
        case haveReply = "have_reply"
        case actcomPhoto = "actcom_photo"
        
    }
}
