//  
//  SearchEventsViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchEventsViewModelType {
    var inputs: SearchEventsViewModelInputs { get }
    var outputs: SearchEventsViewModelOutputs { get }
}

protocol SearchEventsViewModelInputs {
    func onViewDidLoad()
    func setFilter(keyword: String, fromDate: String, toDate: String, minCost: Int, maxCost: Int, location: String)
    func resetFilter(keyword: String)
    func getAllListEventFiltered()
}

protocol SearchEventsViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: [AllListEventResponse]? { get }
    var request: AllListEventRequest? { get set }
    var keyword: String? { get }
}

class SearchEventsViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var SearchEventsModel: SearchEventsModel?
    var model: [AllListEventResponse]? = []
    var request: AllListEventRequest?
    var keyword: String?
    
    init(keyword: String) {
        super.init()
        self.keyword = keyword
    }
}

// MARK: Private

extension SearchEventsViewModel {
    
}

extension SearchEventsViewModel: SearchEventsViewModelType {
    var inputs: SearchEventsViewModelInputs { return self }
    var outputs: SearchEventsViewModelOutputs { return self }
}

extension SearchEventsViewModel: SearchEventsViewModelInputs {
    
    func onViewDidLoad() {
        request = AllListEventRequest(offset: 0, limit: 100,keyword: keyword,location: nil,startDate: nil,endDate: nil,minPrice: nil,maxPrice: nil)
        getAllListEventFiltered()
    }
    
    func setFilter(keyword: String, fromDate: String, toDate: String, minCost: Int, maxCost: Int, location: String) {
        request = AllListEventRequest(offset: 0, limit: 100,keyword: keyword,location: location,startDate: fromDate,endDate: toDate,minPrice: minCost,maxPrice: maxCost)
        getAllListEventFiltered()
    }
    
    func resetFilter(keyword: String) {
        request = AllListEventRequest(offset: 0, limit: 100,keyword: keyword,location: nil,startDate: nil,endDate: nil,minPrice: nil,maxPrice: nil)
    }
    
    func getAllListEventFiltered() {
        model = []
        lacakinApiProvider.rx
            .request(.allListEvent(request!))
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

extension SearchEventsViewModel: SearchEventsViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable()
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
