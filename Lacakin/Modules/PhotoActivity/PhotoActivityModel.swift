//  
//  PhotoActivityModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct PhotoActivityModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

