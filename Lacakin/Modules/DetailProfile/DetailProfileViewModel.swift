//  
//  DetailProfileViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailProfileViewModelType {
    var inputs: DetailProfileViewModelInputs { get }
    var outputs: DetailProfileViewModelOutputs { get }
}

protocol DetailProfileViewModelInputs {
    func onViewDidLoad()
}

protocol DetailProfileViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var friendProfileModel: Observable<FriendProfileResponse?> { get }
    var userProfileModel: Observable<UserProfileResponse?> { get }
    var friendId: String { get }
    var isUser: Bool { get }
}

class DetailProfileViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var DetailProfileModel: DetailProfileModel?
    var friendProfileModelVariable = Variable<FriendProfileResponse?>(nil)
    var userProfileModelVariable = Variable<UserProfileResponse?>(nil)
    var friendId = ""
    var isUser = true
    
    init(friendId: String, isUser: Bool) {
        super.init()
        self.friendId = friendId
        self.isUser = isUser
    }
}

// MARK: Private

extension DetailProfileViewModel {
    
}

extension DetailProfileViewModel: DetailProfileViewModelType {
    var inputs: DetailProfileViewModelInputs { return self }
    var outputs: DetailProfileViewModelOutputs { return self }
}

extension DetailProfileViewModel: DetailProfileViewModelInputs {
    
    func onViewDidLoad() {
        if isUser {
            getUserProfile()
        } else {
            getFriendProfile()
        }
    }
    
    func getUserProfile() {
        lacakinApiProvider.rx
            .request(.getProfile())
            .mapObject(GetProfileData.self)
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
                        self.userProfileModelVariable.value = response.data
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    //                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getFriendProfile() {
        lacakinApiProvider.rx
            .request(.friendProfile(FriendProfileRequest(friendid: friendId)))
            .mapObject(FriendProfileData.self)
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
                        self.friendProfileModelVariable.value = response.data
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

extension DetailProfileViewModel: DetailProfileViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var friendProfileModel: Observable<FriendProfileResponse?> {
        return friendProfileModelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var userProfileModel: Observable<UserProfileResponse?> {
        return userProfileModelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
}
