//  
//  EventsViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol EventsViewModelType {
    var inputs: EventsViewModelInputs { get }
    var outputs: EventsViewModelOutputs { get }
}

protocol EventsViewModelInputs {
    func onViewDidLoad()
}

protocol EventsViewModelOutputs {
    var update: Observable<Bool> { get }
    var empty: Observable<String> { get }
}

class EventsViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var EventsModel: EventsModel?
    var emptyVariable = Variable<String>("")
    
    init(emptyLabel: String) {
        super.init()
        emptyVariable.value = emptyLabel
    }
}

// MARK: Private

extension EventsViewModel {
    
}

extension EventsViewModel: EventsViewModelType {
    var inputs: EventsViewModelInputs { return self }
    var outputs: EventsViewModelOutputs { return self }
}

extension EventsViewModel: EventsViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension EventsViewModel: EventsViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var empty: Observable<String> {
        return emptyVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
