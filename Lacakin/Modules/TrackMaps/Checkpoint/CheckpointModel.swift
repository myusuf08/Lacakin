//  
//  CheckpointModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct CheckpointModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

