//
//  DefaultKeys.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let userToken = DefaultsKey<String?>("user_token")
    static let headerAccessToken = DefaultsKey<String?>("header_access_token")
    static let userProfile = DefaultsKey<Profile?>("user_profile")
    static let userSocialProfile = DefaultsKey<SocialProfile?>("user_social_profile")
    static let deviceToken = DefaultsKey<String?>("device_token")
    static let userPassword = DefaultsKey<String?>("user_password")
    static let city = DefaultsKey<String?>("city")
    static let lat = DefaultsKey<String?>("lat")
    static let lng = DefaultsKey<String?>("lng")
    static let isTracking = DefaultsKey<Bool?>("isTracking")
    static let isCodeTracking = DefaultsKey<String?>("isCodeTracking")
}
