//  
//  ProfileViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileViewModelType {
    var inputs: ProfileViewModelInputs { get }
    var outputs: ProfileViewModelOutputs { get }
}

protocol ProfileViewModelInputs {
    func onViewDidLoad()
}

protocol ProfileViewModelOutputs {
    var update: Observable<Bool> { get }
}

class ProfileViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var ProfileModel: ProfileModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension ProfileViewModel {
    
}

extension ProfileViewModel: ProfileViewModelType {
    var inputs: ProfileViewModelInputs { return self }
    var outputs: ProfileViewModelOutputs { return self }
}

extension ProfileViewModel: ProfileViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension ProfileViewModel: ProfileViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
}
