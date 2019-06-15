//  
//  FriendActivityViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol FriendActivityViewModelType {
    var inputs: FriendActivityViewModelInputs { get }
    var outputs: FriendActivityViewModelOutputs { get }
}

protocol FriendActivityViewModelInputs {
    func onViewDidLoad()
}

protocol FriendActivityViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var friendActivityModel: FriendActivityData? { get }
    var userActivityModel: ActivityListData? { get }
    var isUser: Bool { get }
}

class FriendActivityViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var friendActivityModel: FriendActivityData?
    var userActivityModel: ActivityListData?
    var friendId = ""
    var isUser = true
    
    init(friendId: String, isUser: Bool) {
        super.init()
        self.friendId = friendId
        self.isUser = isUser
    }
}

// MARK: Private

extension FriendActivityViewModel {
    
}

extension FriendActivityViewModel: FriendActivityViewModelType {
    var inputs: FriendActivityViewModelInputs { return self }
    var outputs: FriendActivityViewModelOutputs { return self }
}

extension FriendActivityViewModel: FriendActivityViewModelInputs {
    
    func onViewDidLoad() {
        if isUser {
            getUserActivity()
        } else {
            getFriendActivity()
        }
    }
    
    func getUserActivity() {
        lacakinApiProvider.rx
            .request(.activityList(ActivityListRequest(page: 1, view: 100)))
            .mapObject(ActivityListData.self)
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
                        self.userActivityModel = response
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
    
    func getFriendActivity() {
        lacakinApiProvider.rx
            .request(.friendActivity(FriendActivityRequest(friendid: friendId)))
            .mapObject(FriendActivityData.self)
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
                        self.friendActivityModel = response
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

extension FriendActivityViewModel: FriendActivityViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
