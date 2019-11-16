//
//  MTQQNotification.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RealmSwift

class MTQQNotificationRealm: Object {
    @objc dynamic var type = ""
    @objc dynamic var from = ""
    @objc dynamic var sticky = false
    @objc dynamic var title = ""
    @objc dynamic var text = ""
    @objc dynamic var actcode = ""
    @objc dynamic var icon = ""
    @objc dynamic var userid = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var channel = 0
    @objc dynamic var isRead = false
}

struct MTQQNotification: Codable {
    let type: String?
    let from: String?
    let sticky: Bool?
    let title: String?
    let text: String?
    let actcode: String?
    let icon: String?
    let userid: String?
    let timestamp: String?
    let channel: Int?
}
