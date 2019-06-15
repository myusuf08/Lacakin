//  
//  ProfileActivityModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ProfileActivityModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

