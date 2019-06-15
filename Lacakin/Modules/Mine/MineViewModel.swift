//  
//  MineViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol MineViewModelType {
    var inputs: MineViewModelInputs { get }
    var outputs: MineViewModelOutputs { get }
}

protocol MineViewModelInputs {
    func onViewDidLoad()
    func getActivityListData() -> ActivityListData?
}

protocol MineViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
}

class MineViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var MineModel: MineModel?
    private let errorStringVariable = Variable<String>("")
    var model: ActivityListData? = nil
    let network = MoyaProvider<LacakinApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension MineViewModel {
    func getActivity() {
        updateVariable.value = true
    }
}

extension MineViewModel: MineViewModelType {
    var inputs: MineViewModelInputs { return self }
    var outputs: MineViewModelOutputs { return self }
}

extension MineViewModel: MineViewModelInputs {
    func getActivityListData() -> ActivityListData? {
        return model
    }
    
    func onViewDidLoad() {
        getActivityList()
    }
    
    func getActivityList() {
        network.rx
            .request(.activityList(ActivityListRequest(page: 1, view: 10)))
            .mapObject(ActivityListData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.updateVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        if response.data?.count == 0 {
                            self.updateVariable.value = false
                            return
                        }
                        self.model = response
                        self.updateVariable.value = true
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
                    self.updateVariable.value = false
                    
            })
            .disposed(by: disposeBag)
    }
}

extension MineViewModel: MineViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable()
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
