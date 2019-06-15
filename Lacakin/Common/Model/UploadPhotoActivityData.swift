//  
//  UploadPhotoActivityData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct UploadPhotoActivityData: Codable {
    let message: String?
    let status: Int?
    let data: UploadPhotoActivityResponse
}

