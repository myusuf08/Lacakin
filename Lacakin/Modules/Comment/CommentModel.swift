//  
//  CommentModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct CommentModel: Codable {
    
    let model: String
    
    init(model: String) {
        self.model = model
    }
}

