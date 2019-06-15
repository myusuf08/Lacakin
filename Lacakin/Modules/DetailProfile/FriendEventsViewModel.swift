//  
//  FriendEventsViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol FriendEventsViewModelType {
    var inputs: FriendEventsViewModelInputs { get }
    var outputs: FriendEventsViewModelOutputs { get }
}

protocol FriendEventsViewModelInputs {
    func onViewDidLoad()
}

protocol FriendEventsViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
}

class FriendEventsViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var FriendEventsModel: FriendEventsModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension FriendEventsViewModel {
    
}

extension FriendEventsViewModel: FriendEventsViewModelType {
    var inputs: FriendEventsViewModelInputs { return self }
    var outputs: FriendEventsViewModelOutputs { return self }
}

extension FriendEventsViewModel: FriendEventsViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension FriendEventsViewModel: FriendEventsViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
