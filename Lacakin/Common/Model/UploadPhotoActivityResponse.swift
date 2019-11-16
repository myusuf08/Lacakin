//  
//  UploadPhotoActivityResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct UploadPhotoActivityResponse: Codable {
    let status: Bool?
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case photoUrl = "photo_url"
        
    }
}
