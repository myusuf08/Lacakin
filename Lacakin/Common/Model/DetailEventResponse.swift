//  
//  DetailEventResponse.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Foundation

struct DetailEventResponse: Codable {
    let eventId: Int?
    let eventName: String?
    let viewer: Int?
    let eventDescription: String?
    let eventType: String?
    let eventCode: String?
    let eventStartDateUnix: Int?
    let eventStartDate: String?
    let eventEndDateUnix: Int?
    let eventEndDate: String?
    let eventRegistrationOpenDateUnix: Int?
    let eventRegistrationOpenDate: String?
    let eventRegistrationCloseDateUnix: Int?
    let eventRegistrationCloseDate: String?
    let eventStartTime: String?
    let eventEndTime: String?
    let eventIsFree: Int?
    let eventLocation: String?
    let eventLocationLatitude: Float?
    let eventLocationLongitude: Float?
    let eventStartPoint: String?
    let eventStartPointLatitude: Float?
    let eventStartPointLongitude: Float?
    let eventIsPublic: Int?
    let eventorFullname: String?
    let eventorId: Int?
    let isRegClose: String?
    let eventTotalQuota: Int?
    let eventPackages: [EventPackages]?
    let eventPhoto: AllListEventPhoto?
    let eventTotalParticipant: Int?
    let adminFee: Int?
    
    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case eventName = "event_name"
        case viewer = "viewer"
        case eventDescription = "event_description"
        case eventType = "event_type"
        case eventCode = "event_code"
        case eventStartDateUnix = "event_start_date_unix"
        case eventStartDate = "event_start_date"
        case eventEndDateUnix = "event_end_date_unix"
        case eventEndDate = "event_end_date"
        case eventRegistrationOpenDateUnix = "event_registration_open_date_unix"
        case eventRegistrationOpenDate = "event_registration_open_date"
        case eventRegistrationCloseDateUnix = "event_registration_close_date_unix"
        case eventRegistrationCloseDate = "event_registration_close_date"
        case eventStartTime = "event_start_time"
        case eventEndTime = "event_end_time"
        case eventIsFree = "event_is_free"
        case eventLocation = "event_location"
        case eventLocationLatitude = "event_location_latitude"
        case eventLocationLongitude = "event_location_longitude"
        case eventStartPoint = "event_start_point"
        case eventStartPointLatitude = "event_start_point_latitude"
        case eventStartPointLongitude = "event_start_point_longitude"
        case eventIsPublic = "event_is_public"
        case eventorFullname = "eventor_fullname"
        case eventorId = "eventor_id"
        case isRegClose = "is_reg_close"
        case eventTotalQuota = "event_total_quota"
        case eventPackages = "event_packages"
        case eventPhoto = "event_photo"
        case eventTotalParticipant = "event_total_participant"
        case adminFee = "admin_fee"
    }
    
    
}
