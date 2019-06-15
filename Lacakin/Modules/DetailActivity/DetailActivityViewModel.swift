//  
//  DetailActivityViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 03/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailActivityViewModelType {
    var inputs: DetailActivityViewModelInputs { get }
    var outputs: DetailActivityViewModelOutputs { get }
}

protocol DetailActivityViewModelInputs {
    func onViewDidLoad()
    func onViewDidAppear()
    func onDetailModel() -> ActivityListResponse?
    func onDetailOthersModel() -> ActivityListOthersResponse?
    func getDetailJoinActivity(fromJoin: Bool)
    func joinActivity()
    func onMemberActivityModel() -> [MemberActivityListList]
    func onMemberActivityOthersModel() -> [MemberActivityListOthersList]
    func onMemberJoinActivityModel() -> [MemberJoinActivityListList]
    func onListPhotoModel() -> [ListPhotoActivityResponse]
    func approveMemberJoinActivity(memId: String)
    func userLikeDislikeActivity()
    func getListPhotoActivity()
    func isMemberValid(status: Bool)
}

protocol DetailActivityViewModelOutputs {
    var update: Observable<Bool> { get }
    var loading: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: Observable<ActivityListResponse?> { get }
    var modelOthers: Observable<ActivityListOthersResponse?> { get }
    var modelDetail: Observable<DetailActivityResponse?> { get }
    var modelDetailJoin: Observable<DetailJoinActivityResponse?> { get }
    var modelDetailBeforeJoin: Observable<DetailBeforeJoinActivityResponse?> { get }
    var joinActivityCode: String { get }
    var memberActivityListModel: MemberActivityListResponse? { get }
    var memberActivityListOthersModel: MemberActivityListOthersResponse? { get }
    var memberJoinActivityListModel: MemberJoinActivityListResponse? { get }
    var listActivityPhotoModel: Observable<[ListPhotoActivityResponse]?> { get }
    var listActivityPhotoModels: [ListPhotoActivityResponse]? { get }
    var countMember: Observable<Int> { get }
    var countLike: Observable<Int> { get }
    var latLong: String { get }
    var location: String { get }
    var isFromJoin: Bool { get }
    var isFromList: Bool { get }
    var isFromFriend: Bool { get }
    var actId: String { get }
    var actCode: String { get }
    var isUserLike: Bool { get }
    var isListImageEmpty: Bool { get }
    var isJoinApproved: Bool { get }
    var isMemberValid: Bool { get }
    var desc: String { get }
    
}

class DetailActivityViewModel: BaseViewModel {

    private let loadingVariable = Variable<Bool>(false)
    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var DetailActivityModel: DetailActivityModel?
    var activityModel: ActivityListResponse?
    var activityOthersModel: ActivityListOthersResponse?
    var modelVariable = Variable<ActivityListResponse?>(nil)
    var modelOthersVariable = Variable<ActivityListOthersResponse?>(nil)
    var modelDetailVariable = Variable<DetailActivityResponse?>(nil)
    var modelDetailJoinVariable = Variable<DetailJoinActivityResponse?>(nil)
    var modelDetailBeforeJoinVariable = Variable<DetailBeforeJoinActivityResponse?>(nil)
    var memberActivityListModel: MemberActivityListResponse?
    var memberActivityListOthersModel: MemberActivityListOthersResponse?
    var memberJoinActivityListModel: MemberJoinActivityListResponse?
    var countMemberVariable = Variable<Int>(0)
    var countLikeVariable = Variable<Int>(0)
    var listActivityPhotoModelVariable = Variable<[ListPhotoActivityResponse]?>([])
    var isFromList = false
    var isFromJoin = false
    var joinActivityCode = ""
    var latLong = ""
    var location = ""
    var isFromFriend = false
    var actId = ""
    var actCode = ""
    var isUserLike = false
    var isListImageEmpty = true
    var isJoinApproved = false
    var isMemberValid = true
    var desc = ""
    
    init(activityModel: ActivityListResponse, activityOthersModel: ActivityListOthersResponse, isFromList: Bool,joinActivityCode: String, isFromFriend: Bool) {
        super.init()
        self.activityModel = activityModel
        self.activityOthersModel = activityOthersModel
        self.isFromList = isFromList
        self.joinActivityCode = joinActivityCode
        self.isFromFriend = isFromFriend
    }
}

// MARK: Private

extension DetailActivityViewModel {
    
}

extension DetailActivityViewModel: DetailActivityViewModelType {
    var inputs: DetailActivityViewModelInputs { return self }
    var outputs: DetailActivityViewModelOutputs { return self }
}

extension DetailActivityViewModel: DetailActivityViewModelInputs {
    
    func onViewDidLoad() {
        if isFromFriend {
            getDetailJoinActivity(fromJoin: true)
        } else {
            if joinActivityCode != "" {
                getDetailBeforeJoinActivity()
            } else {
                if isFromList {
                    getDetailActivity()
                } else {
                    getDetailJoinActivity()
                }
            }
        }
    }
    
    func onViewDidAppear() {
        if isFromFriend {
            getDetailJoinActivity(fromJoin: true)
        } else {
            if joinActivityCode != "" {
                getDetailBeforeJoinActivity()
            } else {
                if isFromList {
                    getDetailActivity()
                } else {
                    getDetailJoinActivity()
                }
            }
        }
    }
    
    func onListPhotoModel() -> [ListPhotoActivityResponse] {
        return listActivityPhotoModels ?? []
    }
    
    func onMemberActivityOthersModel() -> [MemberActivityListOthersList] {
        return memberActivityListOthersModel?.list ?? []
    }
    
    
    func onMemberActivityModel() -> [MemberActivityListList] {
        return memberActivityListModel?.list ?? []
    }
    
    func onMemberJoinActivityModel() -> [MemberJoinActivityListList] {
        return memberJoinActivityListModel?.list ?? []
    }
    
    func onDetailModel() -> ActivityListResponse? {
        return activityModel
    }
    
    func onDetailOthersModel() -> ActivityListOthersResponse? {
        return activityOthersModel
    }
    
    func isMemberValid(status: Bool) {
        isMemberValid = status
    }
    
    func getDetailActivity(fromJoin: Bool = false) {
        var code = ""
        if fromJoin {
            code = joinActivityCode
        } else {
            code = activityModel?.actCode ?? ""
        }
        lacakinApiProvider.rx
            .request(.detailActivity(DetailActivityRequest(code: code)))
            .mapObject(DetailActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        if response.data.actIslike == 0 {
                            self.isUserLike = false
                        } else {
                            self.isUserLike = true
                        }
                        self.isMemberValid = true
                        self.isJoinApproved = true
                        self.desc = response.data.actDesc ?? ""
                        self.actCode = response.data.actCode ?? ""
                        self.actId = "\(response.data.actId ?? 0)"
                        self.location = response.data.actLocation ?? ""
                        self.latLong = response.data.actLatlong ?? ""
                        self.getMemberActivityList(actId: "\(response.data.actId ?? 0)")
                        self.loadingVariable.value = false
                        self.modelDetailVariable.value = response.data
                        self.getListPhotoActivity()
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getDetailBeforeJoinActivity() {
        lacakinApiProvider.rx
            .request(.detailBeforeJoinActivity(DetailBeforeJoinActivityRequest(code: joinActivityCode)))
            .mapObject(DetailBeforeJoinActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        if response.data?.ownerId == User.shared.profile?.userId {
                            self.getDetailActivity(fromJoin: true)
                            return
                        }
                        if response.data?.ismember == true {
                            self.getDetailJoinActivity(fromJoin: true)
                            return
                        }
                        if response.data?.actIslike == 0 {
                            self.isUserLike = false
                        } else {
                            self.isUserLike = true
                        }
                        self.desc = response.data?.actDesc ?? ""
                        self.actCode = response.data?.actCode ?? ""
                        self.actId = "\(response.data?.actId ?? 0)"
                        self.location = response.data?.actLocation ?? ""
                        self.latLong = response.data?.actLatlong ?? ""
                        self.getMemberActivityListOthers(actId: "\(response.data?.actId ?? 0)")
                        self.loadingVariable.value = false
                        self.modelDetailBeforeJoinVariable.value = response.data
                        if response.data?.ismember == false {
                            self.isMemberValid = false
                        } else {
                            self.isMemberValid = true
                        }
                        self.getListPhotoActivity()
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    print("error.localizedDescription \(error.localizedDescription)")
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getDetailJoinActivity(fromJoin: Bool = false) {
        var code = ""
        if fromJoin {
            code = joinActivityCode
        } else {
            code = activityOthersModel?.actCode ?? ""
        }
        lacakinApiProvider.rx
            .request(.detailJoinActivity(DetailJoinActivityRequest(code: code)))
            .mapObject(DetailJoinActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.isFromList = false
                        if response.data.actIslike == 0 {
                            self.isUserLike = false
                        } else {
                            self.isUserLike = true
                        }
                        if response.data.actmemActive == 1 {
                            self.isJoinApproved = true
                            self.isMemberValid = true
                        } else {
                            self.isMemberValid = false
                        }
                        self.desc = response.data.actDesc ?? ""
                        self.actCode = response.data.actCode ?? ""
                        self.actId = "\(response.data.actId ?? 0)"
                        self.location = response.data.actLocation ?? ""
                        self.latLong = response.data.actLatlong ?? ""
                        self.getMemberActivityListOthers(actId: "\(response.data.actId ?? 0)")
                        self.loadingVariable.value = false
                        self.modelDetailJoinVariable.value = response.data
                        self.getListPhotoActivity()
                        self.isFromJoin = false
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func joinActivity() {
        lacakinApiProvider.rx
            .request(.joinActivity(JoinActivityRequest(actcode: joinActivityCode)))
            .mapObject(JoinActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.loadingVariable.value = false
                        self.isFromJoin = true
                        self.getDetailJoinActivity(fromJoin: true)
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func userLikeDislikeActivity() {
        if isUserLike {
            userDislikeActivity()
        } else {
            userLikeActivity()
        }
    }
    
    func userLikeActivity() {
        lacakinApiProvider.rx
            .request(.userLikeActivity(UserLikeActivityRequest(actid: actId)))
            .mapObject(UserLikeActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.isUserLike = true
                        self.loadingVariable.value = false
                        self.countLikeVariable.value = response.data.count ?? 0
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func userDislikeActivity() {
        lacakinApiProvider.rx
            .request(.userDislikeActivity(UserDislikeActivityRequest(actid: actId)))
            .mapObject(UserDislikeActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.isUserLike = false
                        self.loadingVariable.value = false
                        self.countLikeVariable.value = response.data.count ?? 0
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func approveMemberJoinActivity(memId: String) {
        lacakinApiProvider.rx
            .request(.approveMemberActivity(ApproveMemberActivityRequest(actid: "\(activityModel?.actId ?? 0)", memid: memId)))
            .mapObject(ApproveMemberActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.loadingVariable.value = false
                        self.getDetailActivity()
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getMemberActivityList(actId: String) {
        memberActivityListModel = nil
        lacakinApiProvider.rx
            .request(.memberActivityList(MemberActivityListRequest(actid: actId, page: "1", view: "100")))
            .mapObject(MemberActivityListData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.countMemberVariable.value = response.data.count ?? 0
                        self.memberActivityListModel = response.data
                        self.loadingVariable.value = false
                        self.updateVariable.value = true
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getMemberActivityListOthers(actId: String) {
        memberActivityListModel = nil
        lacakinApiProvider.rx
            .request(.memberActivityListOthers(MemberActivityListOthersRequest(actid: actId, page: "1", view: "100")))
            .mapObject(MemberActivityListOthersData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.countMemberVariable.value = response.data.count ?? 0
                        self.memberActivityListOthersModel = response.data
                        self.loadingVariable.value = false
                        self.updateVariable.value = true
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getMemberJoinActivityList(code: String) {
        memberJoinActivityListModel = nil
        lacakinApiProvider.rx
            .request(.memberJoinActivityList(MemberJoinActivityListRequest(code: code, page: "1", view: "100")))
            .mapObject(MemberJoinActivityListData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.countMemberVariable.value = response.data.count ?? 0
                        self.memberJoinActivityListModel = response.data
                        self.loadingVariable.value = false
                        self.updateVariable.value = true
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getListPhotoActivity() {
        lacakinApiProvider.rx
            .request(.listPhotoActivity(ListPhotoActivityRequest(actid: actId)))
            .mapObject(ListPhotoActivityData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.loadingVariable.value = false
                        if response.data?.count ?? 0 > 0 {
                            self.isListImageEmpty = false
                        }
                        self.listActivityPhotoModelVariable.value = response.data
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    print("error.localizedDescription \(error.localizedDescription)")
                    self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension DetailActivityViewModel: DetailActivityViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var model: Observable<ActivityListResponse?> {
        return modelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var modelOthers: Observable<ActivityListOthersResponse?> {
        return modelOthersVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var modelDetail: Observable<DetailActivityResponse?> {
        return modelDetailVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var modelDetailJoin: Observable<DetailJoinActivityResponse?> {
        return modelDetailJoinVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var modelDetailBeforeJoin: Observable<DetailBeforeJoinActivityResponse?> {
        return modelDetailBeforeJoinVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var listActivityPhotoModel: Observable<[ListPhotoActivityResponse]?> {
        return listActivityPhotoModelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var loading: Observable<Bool> {
        return loadingVariable.asObservable()
    }
    
    var countMember: Observable<Int> {
        return countMemberVariable.asObservable().map { $0 }
    }
    
    var countLike: Observable<Int> {
        return countLikeVariable.asObservable().map { $0 }
    }
    
    var listActivityPhotoModels: [ListPhotoActivityResponse]? {
        return listActivityPhotoModelVariable.value
    }
}
