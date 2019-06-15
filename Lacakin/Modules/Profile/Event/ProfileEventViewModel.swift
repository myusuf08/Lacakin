//  
//  ProfileEventViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileEventViewModelType {
    var inputs: ProfileEventViewModelInputs { get }
    var outputs: ProfileEventViewModelOutputs { get }
}

protocol ProfileEventViewModelInputs {
    func onViewDidLoad()
}

protocol ProfileEventViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
}

class ProfileEventViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var ProfileEventModel: ProfileEventModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension ProfileEventViewModel {
    
}

extension ProfileEventViewModel: ProfileEventViewModelType {
    var inputs: ProfileEventViewModelInputs { return self }
    var outputs: ProfileEventViewModelOutputs { return self }
}

extension ProfileEventViewModel: ProfileEventViewModelInputs {
    
    func onViewDidLoad() {
        
    }
}

extension ProfileEventViewModel: ProfileEventViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
