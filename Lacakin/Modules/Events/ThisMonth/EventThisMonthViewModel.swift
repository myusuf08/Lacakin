//  
//  EventThisMonthViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol EventThisMonthViewModelType {
    var inputs: EventThisMonthViewModelInputs { get }
    var outputs: EventThisMonthViewModelOutputs { get }
}

protocol EventThisMonthViewModelInputs {
    func onViewDidLoad()
}

protocol EventThisMonthViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var empty: Observable<String> { get }
    var model: [ThisMonthListEventResponse]? { get }
}

class EventThisMonthViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var EventThisMonthModel: EventThisMonthModel?
    var emptyVariable = Variable<String>("")
    var model: [ThisMonthListEventResponse]? = []
    
    init(emptyLabel: String) {
        super.init()
        emptyVariable.value = emptyLabel
    }
}

// MARK: Private

extension EventThisMonthViewModel {
    
}

extension EventThisMonthViewModel: EventThisMonthViewModelType {
    var inputs: EventThisMonthViewModelInputs { return self }
    var outputs: EventThisMonthViewModelOutputs { return self }
}

extension EventThisMonthViewModel: EventThisMonthViewModelInputs {
    
    func onViewDidLoad() {
        getAllListEvent()
    }
    
    func getAllListEvent() {
        lacakinApiProvider.rx
            .request(.thisMonthListEvent(ThisMonthListEventRequest(offset: 0, limit: 100)))
            .mapObject(ThisMonthListEventData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.model = response.data
                        if self.model?.count == 0 {
                            self.updateVariable.value = false
                            return
                        }
                        self.updateVariable.value = true
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    print("eror = \(error.localizedDescription)")
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension EventThisMonthViewModel: EventThisMonthViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable()
    }
    
    var empty: Observable<String> {
        return emptyVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
