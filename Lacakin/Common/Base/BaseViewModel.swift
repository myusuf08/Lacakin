//
//  BaseViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

class BaseViewModel: NSObject {
    
    enum NetworkingViewState {
        case none
        case loading
        case success
        case error(message: String)
    }
    
    let disposeBag = DisposeBag()
    var viewState = Variable<NetworkingViewState>(.none)
    
}
