//  
//  NotificationsViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol NotificationsViewModelType {
    var inputs: NotificationsViewModelInputs { get }
    var outputs: NotificationsViewModelOutputs { get }
}

protocol NotificationsViewModelInputs {
    func onViewDidLoad()
}

protocol NotificationsViewModelOutputs {
    var update: Observable<Bool> { get }
}

class NotificationsViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var NotificationsModel: NotificationsModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension NotificationsViewModel {
    
}

extension NotificationsViewModel: NotificationsViewModelType {
    var inputs: NotificationsViewModelInputs { return self }
    var outputs: NotificationsViewModelOutputs { return self }
}

extension NotificationsViewModel: NotificationsViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension NotificationsViewModel: NotificationsViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
}
