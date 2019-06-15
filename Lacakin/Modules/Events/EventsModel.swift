//  
//  EventsModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct EventsModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

