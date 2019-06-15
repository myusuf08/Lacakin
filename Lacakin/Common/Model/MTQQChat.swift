//
//  MTQQChat.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct MTQQChat: Codable {
    let chatUid: String?
    let chatUserId: String?
    let chatUserName: String?
    let chatUserPhoto: String?
    let chatTime: String?
    let chatMsg: String?
    let chatGroupCode: String?
    let channel: Int?
    let chatSent: Int?
    
    enum CodingKeys: String, CodingKey {
        case chatUid = "chat_uid"
        case chatUserId = "chat_user_id"
        case chatUserName = "chat_user_name"
        case chatUserPhoto = "chat_user_photo"
        case chatTime = "chat_time"
        case chatMsg = "chat_msg"
        case chatGroupCode = "chat_group_code"
        case channel = "channel"
        case chatSent = "chat_sent"
    }
}
