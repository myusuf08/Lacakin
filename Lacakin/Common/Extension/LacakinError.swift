//
//  LacakinError.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 12/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

class LacakinError: NSError {
    
    convenience init(code: Int, description: String?) {
        self.init(domain: "Error", code: code, userInfo: [NSLocalizedDescriptionKey: description ?? ""])
    }
}
