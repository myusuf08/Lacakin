//  
//  EventRegisteredViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol EventRegisteredViewModelType {
    var inputs: EventRegisteredViewModelInputs { get }
    var outputs: EventRegisteredViewModelOutputs { get }
}

protocol EventRegisteredViewModelInputs {
    func onViewDidLoad()
}

protocol EventRegisteredViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var empty: Observable<String> { get }
    var model: [RegisteredListEventResponse]? { get }
}

class EventRegisteredViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var EventRegisteredModel: EventRegisteredModel?
    var emptyVariable = Variable<String>("")
    var model: [RegisteredListEventResponse]? = []
    
    init(emptyLabel: String) {
        super.init()
        emptyVariable.value = emptyLabel
    }
}

// MARK: Private

extension EventRegisteredViewModel {
    
}

extension EventRegisteredViewModel: EventRegisteredViewModelType {
    var inputs: EventRegisteredViewModelInputs { return self }
    var outputs: EventRegisteredViewModelOutputs { return self }
}

extension EventRegisteredViewModel: EventRegisteredViewModelInputs {
    
    func onViewDidLoad() {
        getAllListEvent()
    }
    
    func getAllListEvent() {
        let userId = User.shared.profile?.userId ?? ""
        lacakinApiProvider.rx
            .request(.registeredListEvent(RegisteredListEventRequest(offset: 0, limit: 100, userId: Int(userId))))
            .mapObject(RegisteredListEventData.self)
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

extension EventRegisteredViewModel: EventRegisteredViewModelOutputs {
    
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
