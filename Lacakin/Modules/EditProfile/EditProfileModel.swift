//  
//  EditProfileModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EditProfileModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

