//
//  PackagesEquipment.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct PackagesEquipment: Codable {
    
    let equipmentEventpackId: Int?
    let equipmentId: Int?
    let equipmentName: String?
    let equipmentDescription: String?
    let equipmentType: String?
    let equipmentMetricOption: String?
    
    enum CodingKeys: String, CodingKey {
        case equipmentEventpackId = "equipment_eventpack_id"
        case equipmentId = "equipment_id"
        case equipmentName = "equipment_name"
        case equipmentDescription = "equipment_description"
        case equipmentType = "equipment_type"
        case equipmentMetricOption = "equipment_metric_option"
    }
}
