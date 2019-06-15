//  
//  StandartViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol StandartViewModelType {
    var inputs: StandartViewModelInputs { get }
    var outputs: StandartViewModelOutputs { get }
}

protocol StandartViewModelInputs {
    func onViewDidLoad()
}

protocol StandartViewModelOutputs {
    var update: Observable<Bool> { get }
    var title: Observable<String> { get }
}

class StandartViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let titleNavigation = Variable<String>("")
    var StandartModel: StandartModel?
    
    init(title: String) {
        super.init()
        self.titleNavigation.value = title
    }
}

// MARK: Private

extension StandartViewModel {
    
}

extension StandartViewModel: StandartViewModelType {
    var inputs: StandartViewModelInputs { return self }
    var outputs: StandartViewModelOutputs { return self }
}

extension StandartViewModel: StandartViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension StandartViewModel: StandartViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var title: Observable<String> {
        return titleNavigation.asObservable()
    }
}
