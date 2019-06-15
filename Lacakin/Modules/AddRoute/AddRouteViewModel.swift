//  
//  AddRouteViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol AddRouteViewModelType {
    var inputs: AddRouteViewModelInputs { get }
    var outputs: AddRouteViewModelOutputs { get }
}

protocol AddRouteViewModelInputs {
    func onViewDidLoad()
}

protocol AddRouteViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
}

class AddRouteViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var AddRouteModel: AddRouteModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension AddRouteViewModel {
    
}

extension AddRouteViewModel: AddRouteViewModelType {
    var inputs: AddRouteViewModelInputs { return self }
    var outputs: AddRouteViewModelOutputs { return self }
}

extension AddRouteViewModel: AddRouteViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension AddRouteViewModel: AddRouteViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
