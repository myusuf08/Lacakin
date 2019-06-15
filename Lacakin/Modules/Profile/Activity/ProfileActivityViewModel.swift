//  
//  ProfileActivityViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileActivityViewModelType {
    var inputs: ProfileActivityViewModelInputs { get }
    var outputs: ProfileActivityViewModelOutputs { get }
}

protocol ProfileActivityViewModelInputs {
    func onViewDidLoad()
}

protocol ProfileActivityViewModelOutputs {
    var update: Observable<Bool> { get }
}

class ProfileActivityViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var ProfileActivityModel: ProfileActivityModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension ProfileActivityViewModel {
    
}

extension ProfileActivityViewModel: ProfileActivityViewModelType {
    var inputs: ProfileActivityViewModelInputs { return self }
    var outputs: ProfileActivityViewModelOutputs { return self }
}

extension ProfileActivityViewModel: ProfileActivityViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension ProfileActivityViewModel: ProfileActivityViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
}
