//  
//  ActivityModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ActivityModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

