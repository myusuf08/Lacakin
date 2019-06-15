//
//  User.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class User {
    
    static let shared = User()
    
    func clearUserData() {
        token = nil
        profile = nil
        socialProfile = nil
    }
    
    var header: String? {
        get {
            return Defaults[.headerAccessToken]
        }
        set {
            Defaults[.headerAccessToken] = newValue
        }
    }
    
    var token: String? {
        get {
            return Defaults[.userToken]
        }
        set {
            Defaults[.userToken] = newValue
        }
    }
    
    var profile: Profile? {
        get {
            return Defaults[.userProfile]
        }
        set {
            Defaults[.userProfile] = newValue
        }
    }
    
    var socialProfile: SocialProfile? {
        get {
            return Defaults[.userSocialProfile]
        }
        set {
            Defaults[.userSocialProfile] = newValue
        }
    }
    
    var deviceToken: String? {
        get {
            return Defaults[.deviceToken]
        }
        set {
            Defaults[.deviceToken] = newValue
        }
    }
    
    var userPassword: String? {
        get {
            return Defaults[.userPassword]
        }
        set {
            Defaults[.userPassword] = newValue
        }
    }
    
    var city: String? {
        get {
            return Defaults[.city]
        }
        set {
            Defaults[.city] = newValue
        }
    }
    
    var lat: String? {
        get {
            return Defaults[.lat]
        }
        set {
            Defaults[.lat] = newValue
        }
    }
    
    var lng: String? {
        get {
            return Defaults[.lng]
        }
        set {
            Defaults[.lng] = newValue
        }
    }
    
    var isTracking: Bool? {
        get {
            return Defaults[.isTracking]
        }
        set {
            Defaults[.isTracking] = newValue
        }
    }
    
    var isCodeTracking: String? {
        get {
            return Defaults[.isCodeTracking]
        }
        set {
            Defaults[.isCodeTracking] = newValue
        }
    }
}
