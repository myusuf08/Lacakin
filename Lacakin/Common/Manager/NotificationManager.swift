//
//  NotificationManager.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum NotificationType {
    case showPopupCode
    
    var name: Notification.Name {
        switch self {
        case .showPopupCode:
            return Notification.Name(rawValue: "NotificationType.showPopupCode")
        }
    }
}

struct NotificationManager {
    static func observe(_ type: NotificationType,
                        object: Any? = nil) -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(type.name)
    }
    
    static func post(_ type: NotificationType,
                     object: Any? = nil,
                     userInfo: [AnyHashable: Any] = [:]) {
        NotificationCenter.default.post(
            name: type.name,
            object: object,
            userInfo: userInfo)
    }
}
