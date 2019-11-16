//
//  AllListEventPhoto.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AllListEventPhoto: Codable {
    let photoId: Int?
    let photoTitle: String?
//    let photoDescription: String?
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case photoId = "photo_id"
        case photoTitle = "photo_title"
//        case photoDescription = "photo_description"
        case photoUrl = "photo_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photoId = try container.decodeIfPresent(Int.self, forKey: .photoId)
        self.photoTitle = try container.decodeIfPresent(String.self, forKey: .photoTitle)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
    }
}
