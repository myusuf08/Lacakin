//
//  AllListEventPhoto.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AllListEventPhotos: Codable {
    let photoId: Int?
    let photoTitle: String?
    let photoDescription: String?
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case photoId = "photo_id"
        case photoTitle = "photo_title"
        case photoDescription = "photo_description"
        case photoUrl = "photo_url"
    }

}
