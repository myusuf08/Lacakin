//
//  Encodable.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 07/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
