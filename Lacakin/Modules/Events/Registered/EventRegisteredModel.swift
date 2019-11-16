//  
//  EventRegisteredModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EventRegisteredModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

