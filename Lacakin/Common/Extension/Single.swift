//
//  Single.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 07/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    
    public func mapObject<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<T> {
        return flatMap { response -> Single<T> in
            return Single.just(try response.mapObject(type, path: path))
        }
    }
    
    public func mapArray<T: Codable>(_ type: T.Type, path: String? = nil) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            return Single.just(try response.mapArray(type, path: path))
        }
    }
}
