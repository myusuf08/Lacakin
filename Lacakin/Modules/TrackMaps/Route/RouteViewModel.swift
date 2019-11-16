//  
//  RouteViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol RouteViewModelType {
    var inputs: RouteViewModelInputs { get }
    var outputs: RouteViewModelOutputs { get }
}

protocol RouteViewModelInputs {
    func onViewDidLoad()
}

protocol RouteViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var routeModel: [ListRouteResponse]? { get }
    var code: String { get }
}

class RouteViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var routeModel: [ListRouteResponse]?
    var code = ""
    
    init(code: String) {
        super.init()
        self.code = code
    }
}

// MARK: Private

extension RouteViewModel {
    
}

extension RouteViewModel: RouteViewModelType {
    var inputs: RouteViewModelInputs { return self }
    var outputs: RouteViewModelOutputs { return self }
}

extension RouteViewModel: RouteViewModelInputs {
    
    func onViewDidLoad() {
        getListRoute()
    }
    
    func getListRoute() {
        lacakinApiProvider.rx
            .request(.listRoute(ListRouteRequest(code: code)))
            .mapObject(ListRouteData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.routeModel = response.data
                        self.updateVariable.value = true
                        // self.loadingVariable.value = false
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    // self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension RouteViewModel: RouteViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
