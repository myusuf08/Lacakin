//  
//  ProfileEventModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ProfileEventModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

