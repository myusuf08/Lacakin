//  
//  ThisMonthListEventResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct ThisMonthListEventResponse: Codable {
    let eventId: Int?
    let eventName: String?
    let eventType: String?
    let viewer: Int?
    let eventStartDateUnix: Int?
    let eventStartDate: String?
    let eventStartTime: String?
    let eventEndDateUnix: Int?
    let eventEndDate: String?
    let eventEndTime: String?
    let eventRegistrationOpenDate: Int?
    let eventRegistrationCloseDate: Int?
    let eventLocationId: String?
    let eventLocation: String?
    let eventMinPrice: Int?
    let eventMaxPrice: Int?
    let eventIsFree: Int?
    let isRegClose: String?
    let eventPhoto: AllListEventPhoto?
    let eventTotalParticipant: Int?
    let adminFee: Int?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case eventName = "event_name"
        case eventType = "event_type"
        case viewer = "viewer"
        case eventStartDateUnix = "event_start_date_unix"
        case eventStartDate = "event_start_date"
        case eventStartTime = "event_start_time"
        case eventEndDateUnix = "event_end_date_unix"
        case eventEndDate = "event_end_date"
        case eventEndTime = "event_end_time"
        case eventRegistrationOpenDate = "event_registration_open_date"
        case eventRegistrationCloseDate = "event_registration_close_date"
        case eventLocationId = "event_location_id"
        case eventLocation = "event_location"
        case eventMinPrice = "event_min_price"
        case eventMaxPrice = "event_max_price"
        case eventIsFree = "event_is_free"
        case isRegClose = "is_reg_close"
        case eventPhoto = "event_photo"
        case eventTotalParticipant = "event_total_participant"
        case adminFee = "admin_fee"
    }
}
