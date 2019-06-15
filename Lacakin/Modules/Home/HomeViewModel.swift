//  
//  HomeViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

protocol HomeViewModelInputs {
    func onViewDidLoad()
}

protocol HomeViewModelOutputs {
    var update: Observable<Bool> { get }
}

class HomeViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var HomeModel: HomeModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension HomeViewModel {
    
}

extension HomeViewModel: HomeViewModelType {
    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
}

extension HomeViewModel: HomeViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension HomeViewModel: HomeViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
}
