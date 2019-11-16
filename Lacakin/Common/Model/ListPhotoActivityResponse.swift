//  
//  ListPhotoActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ListPhotoActivityResponse: Codable {
    let actphoId: Int?
    let actphoPhotourl: String?
    let actphoTitle: String?
    let actphoDate: Int?
    let uploader: String?
    let uploaderId: String?
    let photoUploader: String?
    
    enum CodingKeys: String, CodingKey {
        case actphoId = "actpho_id"
        case actphoPhotourl = "actpho_photourl"
        case actphoTitle = "actpho_title"
        case actphoDate = "actpho_date"
        case uploader = "uploader"
        case uploaderId = "uploader_id"
        case photoUploader = "photo_uploader"
        
    }
}
