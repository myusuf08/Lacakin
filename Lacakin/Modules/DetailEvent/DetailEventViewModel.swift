//  
//  DetailEventViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailEventViewModelType {
    var inputs: DetailEventViewModelInputs { get }
    var outputs: DetailEventViewModelOutputs { get }
}

protocol DetailEventViewModelInputs {
    func onViewDidLoad()
}

protocol DetailEventViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: DetailEventResponse? { get }
}

class DetailEventViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var DetailEventModel: DetailEventModel?
    var model: DetailEventResponse?
    var eventId = ""
    
    init(eventId: String) {
        super.init()
        self.eventId = eventId
    }
}

// MARK: Private

extension DetailEventViewModel {
    
}

extension DetailEventViewModel: DetailEventViewModelType {
    var inputs: DetailEventViewModelInputs { return self }
    var outputs: DetailEventViewModelOutputs { return self }
}

extension DetailEventViewModel: DetailEventViewModelInputs {
    
    func onViewDidLoad() {
        getDetailEvent()
    }
    
    func getDetailEvent() {
        lacakinApiProvider.rx
            .request(.detailEvent(DetailEventRequest(eventId: eventId)))
            .mapObject(DetailEventData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.model = response.data
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

extension DetailEventViewModel: DetailEventViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
