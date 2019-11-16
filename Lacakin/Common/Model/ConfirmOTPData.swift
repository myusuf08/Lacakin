//
//  ConfirmOTPData.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct ConfirmOTPData: Codable {
    let message: String?
    let status: Int?
    let data: ConfirmOTPResponse
}
