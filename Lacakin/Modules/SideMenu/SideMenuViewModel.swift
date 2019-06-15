//  
//  SideMenuViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol SideMenuViewModelType {
    var inputs: SideMenuViewModelInputs { get }
    var outputs: SideMenuViewModelOutputs { get }
}

protocol SideMenuViewModelInputs {
    func onViewDidLoad()
    func onViewDidAppear()
}

protocol SideMenuViewModelOutputs {
    var update: Observable<Profile?> { get }
}

class SideMenuViewModel: BaseViewModel {

    private let updateVariable = Variable<Profile?>(nil)
    var SideMenuModel: SideMenuModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension SideMenuViewModel {
    
}

extension SideMenuViewModel: SideMenuViewModelType {
    var inputs: SideMenuViewModelInputs { return self }
    var outputs: SideMenuViewModelOutputs { return self }
}

extension SideMenuViewModel: SideMenuViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func onViewDidAppear() {
        updateVariable.value = User.shared.profile
    }
}

extension SideMenuViewModel: SideMenuViewModelOutputs {
    
    var update: Observable<Profile?> {
        return updateVariable.asObservable().filter { $0 != nil }.map{ $0 }
    }
}
