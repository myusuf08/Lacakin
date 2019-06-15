//  
//  CommentViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentViewModelType {
    var inputs: CommentViewModelInputs { get }
    var outputs: CommentViewModelOutputs { get }
}

protocol CommentViewModelInputs {
    func onViewDidLoad()
    func onMessageText(text: String)
    func commentActivity()
}

protocol CommentViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: [ListCommentActivityResponse]? { get }
}

class CommentViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var CommentModel: CommentModel?
    var actCode = ""
    var actId = ""
    var text = ""
    var model: [ListCommentActivityResponse]? = []
    
    init(actCode: String, actId: String) {
        super.init()
        self.actId = actId
        self.actCode = actCode
    }
}

// MARK: Private

extension CommentViewModel {
    
}

extension CommentViewModel: CommentViewModelType {
    var inputs: CommentViewModelInputs { return self }
    var outputs: CommentViewModelOutputs { return self }
}

extension CommentViewModel: CommentViewModelInputs {
    
    func onViewDidLoad() {
        getListComment()
    }
    
    func onMessageText(text: String) {
        self.text = text
    }
    
    func getListComment() {
        lacakinApiProvider.rx
            .request(.listCommentActivity(ListCommentActivityRequest(actid: Int(actId), actcode: actCode, page: 1, view: 100)))
            .mapObject(ListCommentActivityData.self)
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
    
    func commentActivity() {
        if text == "" {
            errorStringVariable.value = "Field not complete"
            return
        }
        lacakinApiProvider.rx
            .request(.commentActivity(CommentActivityRequest(actid: actId, actcode: actCode, text: text)))
            .mapObject(CommentActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        //self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        //self.loadingVariable.value = false
                        self.getListComment()
                        NotificationCenter.default.post(name: Notification.Name("updateComment"), object: nil, userInfo: nil)
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    //self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension CommentViewModel: CommentViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
}
