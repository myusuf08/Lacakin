//
//  PrimitiveSequence+Scheduler.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 06/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import Foundation
import RxSwift

public extension PrimitiveSequence {
    
    public func subscribeOnBackground() -> PrimitiveSequence<Trait, Element> {
        return subscribeOn(ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background))
    }
    
    public func observeOnUiThread() -> PrimitiveSequence<Trait, Element> {
        return observeOn(MainScheduler.instance)
    }
    
    public func applyDefaultScheduler() -> PrimitiveSequence<Trait, Element> {
        return subscribeOnBackground().observeOnUiThread()
    }
}
