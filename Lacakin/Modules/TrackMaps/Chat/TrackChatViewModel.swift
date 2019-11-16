//  
//  TrackChatViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol TrackChatViewModelType {
    var inputs: TrackChatViewModelInputs { get }
    var outputs: TrackChatViewModelOutputs { get }
}

protocol TrackChatViewModelInputs {
    func onViewDidLoad()
    func onMessageText(text: String)
    func onAddChat(model: ListGroupChatResponse)
}

protocol TrackChatViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: [ListGroupChatResponse]? { get }
    var code: String { get }
}

class TrackChatViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var TrackChatModel: TrackChatModel?
    var model: [ListGroupChatResponse]?
    var text = ""
    var code = ""
    
    init(code: String) {
        super.init()
        self.code = code
    }
}

// MARK: Private

extension TrackChatViewModel {
    
}

extension TrackChatViewModel: TrackChatViewModelType {
    var inputs: TrackChatViewModelInputs { return self }
    var outputs: TrackChatViewModelOutputs { return self }
}

extension TrackChatViewModel: TrackChatViewModelInputs {
    
    func onViewDidLoad() {
        getListChat()
    }
    
    func onAddChat(model: ListGroupChatResponse) {
        self.model?.append(model)
        updateVariable.value = true
    }
    
    func onMessageText(text: String) {
        self.text = text
    }
    
    func getListChat() {
        lacakinApiProvider.rx
            .request(.listGroupChat(ListGroupChatRequest(code: code, page: 1, view: 1000)))
            .mapObject(ListGroupChatData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        //                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        //                        self.loadingVariable.value = false
                        self.model = response.data
                        self.updateVariable.value = true
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    //                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension TrackChatViewModel: TrackChatViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
