//  
//  RegisterModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct RegisterModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

