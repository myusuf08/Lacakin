//
//  AllListParticipation.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct AllListParticipation: Codable {
    let participantId: Int?
    let participantRegistrationDate: String?
    let participantRegistrationDateUnix: Int?
    
    enum CodingKeys: String, CodingKey {
        case participantId = "participant_id"
        case participantRegistrationDate = "participant_registration_date"
        case participantRegistrationDateUnix = "participant_registration_date_unix"
    }
    
}
