//  
//  LikeActivityViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol LikeActivityViewModelType {
    var inputs: LikeActivityViewModelInputs { get }
    var outputs: LikeActivityViewModelOutputs { get }
}

protocol LikeActivityViewModelInputs {
    func onViewDidLoad()
}

protocol LikeActivityViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: [ListLikeActivityResponse]? { get }
    var count: Int { get }
}

class LikeActivityViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var LikeActivityModel: LikeActivityModel?
    var model: [ListLikeActivityResponse]? = []
    var actId = ""
    var actCode = ""
    var count: Int = 0
    
    init(actId: String, actCode: String) {
        super.init()
        self.actCode = actCode
        self.actId = actId
    }
}

// MARK: Private

extension LikeActivityViewModel {
    
}

extension LikeActivityViewModel: LikeActivityViewModelType {
    var inputs: LikeActivityViewModelInputs { return self }
    var outputs: LikeActivityViewModelOutputs { return self }
}

extension LikeActivityViewModel: LikeActivityViewModelInputs {
    
    func onViewDidLoad() {
        getListLikeActivity()
    }
    
    func getListLikeActivity() {
        lacakinApiProvider.rx
            .request(.listLikeActivity(ListLikeActivityRequest(actid: actId, actcode: actCode)))
            .mapObject(ListLikeActivityData.self)
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
                        self.model = response.data
                        self.count = response.data?.count ?? 0
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

extension LikeActivityViewModel: LikeActivityViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
