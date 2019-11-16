//  
//  EventsViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol EventsViewModelType {
    var inputs: EventsViewModelInputs { get }
    var outputs: EventsViewModelOutputs { get }
}

protocol EventsViewModelInputs {
    func onViewDidLoad()
}

protocol EventsViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var empty: Observable<String> { get }
    var model: [AllListEventResponse]? { get }
}

class EventsViewModel: BaseViewModel {

    private let errorStringVariable = Variable<String>("")
    private let updateVariable = Variable<Bool>(false)
    var EventsModel: EventsModel?
    var emptyVariable = Variable<String>("")
    var model: [AllListEventResponse]? = []
    
    init(emptyLabel: String) {
        super.init()
        emptyVariable.value = emptyLabel
    }
}

// MARK: Private

extension EventsViewModel {
    
}

extension EventsViewModel: EventsViewModelType {
    var inputs: EventsViewModelInputs { return self }
    var outputs: EventsViewModelOutputs { return self }
}

extension EventsViewModel: EventsViewModelInputs {
    
    func onViewDidLoad() {
        getAllListEvent()
    }
    
    func getAllListEvent() {
        lacakinApiProvider.rx
            .request(.allListEvent(AllListEventRequest(offset: 0, limit: 100,keyword: nil,location: nil,startDate: nil,endDate: nil,minPrice: nil,maxPrice: nil)))
            .mapObject(AllListEventData.self)
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

extension EventsViewModel: EventsViewModelOutputs {
    
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
