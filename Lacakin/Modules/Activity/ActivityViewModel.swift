//  
//  ActivityViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

enum ActivityCell: Int {
    case title = 0
    case time
    case location
    case desc
    case controls
    
    static var count = 5
}

protocol ActivityViewModelType {
    var inputs: ActivityViewModelInputs { get }
    var outputs: ActivityViewModelOutputs { get }
}

protocol ActivityViewModelInputs {
    func onViewDidLoad()
    func onAddActivityClicked()
    func onTitleChanged(_ text: String)
    func onDescChanged(_ text: String)
    func onDateChanged(_ text: String)
    func onTimeChanged(_ text: String)
    func onLocationChanged(_ text: String)
    func onLatLongChanged(_ text: String)
    func onTimeZoneChanged(_ text: String)
    func onPublicChanged(_ text: String)
    func onJoinApprovalChanged(_ text: String)
}

protocol ActivityViewModelOutputs {
    var update: Observable<Bool> { get }
    var loading: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var shouldNotifySaveSuccess: Observable<Bool> { get }
    var actLocation: String { get }
}

class ActivityViewModel: BaseViewModel {
    
    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    private let notifySaveSuccessVariable = Variable<Bool>(false)
    private let loadingVariable = Variable<Bool>(false)
    var ActivityModel: ActivityModel?
    var actName = ""
    var actDesc = ""
    var actDateStart = ""
    var actTimeStart = ""
    var actLocation = ""
    var actLatlong = ""
    var actTimezone = ""
    var actPublic = ""
    var actJoinApproval = ""
    var isEdit = false
    var idActivity = ""
    
    init(isEdit: Bool, idActivity: String) {
        super.init()
        self.isEdit = isEdit
        self.idActivity = idActivity
    }
}

// MARK: Private

extension ActivityViewModel {
    
}

extension ActivityViewModel: ActivityViewModelType {
    var inputs: ActivityViewModelInputs { return self }
    var outputs: ActivityViewModelOutputs { return self }
}

extension ActivityViewModel: ActivityViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func onTitleChanged(_ text: String) {
        actName = text
    }
    
    func onDescChanged(_ text: String) {
        actDesc = text
    }
    
    func onDateChanged(_ text: String) {
        actDateStart = text
    }
    
    func onTimeChanged(_ text: String) {
        actTimeStart = text
    }
    
    func onLocationChanged(_ text: String) {
        actLocation = text
    }
    
    func onLatLongChanged(_ text: String) {
        actLatlong = text
    }
    
    func onTimeZoneChanged(_ text: String) {
        actTimezone = text
    }
    
    func onPublicChanged(_ text: String) {
        actPublic = text
    }
    
    func onJoinApprovalChanged(_ text: String) {
        actJoinApproval = text
    }
    
    func onAddActivityClicked() {
//        actLocation = User.shared.city ?? "Jakarta"
//        actLatlong = "\(User.shared.lat ?? "-6.21462"),\(User.shared.lng ?? "106.84513")"
        if actName == "" {
            errorStringVariable.value = "Title must not be filled"
            return
        }
        if actDesc == "" || actDesc == "Add Description..." {
            errorStringVariable.value = "Description must be filled"
            return
        }
        if actLocation == "" {
            errorStringVariable.value = "Location must be filled"
            return
        }
        loadingVariable.value = true
        let dateTime = "\(actDateStart) \(actTimeStart)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let timeInterval = "\(dateFormatter.date(from: dateTime)?.timeIntervalSince1970 ?? 0)"
        if isEdit {
            lacakinApiProvider.rx
                .request(.editActivity(EditActivityRequest(actName:actName,actDesc:actDesc,actDateTimeStart:timeInterval,actLocation:actLocation,actLatlong:actLatlong,actTimezone:"Jakarta",actPublic:actPublic,actJoinApproval:actJoinApproval, actId: idActivity)))
                .mapObject(AddActivityData.self)
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
                            self.notifySaveSuccessVariable.value = true
                        }
                    },
                    onError: { [weak self] error in
                        guard let `self` = self else { return }
                        self.loadingVariable.value = false
                        self.errorStringVariable.value = error.localizedDescription
                })
                .disposed(by: disposeBag)
        } else {
            lacakinApiProvider.rx
                .request(.addActivity(AddActivityRequest(actName:actName,actDesc:actDesc,actDateTimeStart:timeInterval,actLocation:actLocation,actLatlong:actLatlong,actTimezone:"Jakarta",actPublic:actPublic,actJoinApproval:actJoinApproval)))
                .mapObject(AddActivityData.self)
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
                            self.notifySaveSuccessVariable.value = true
                        }
                    },
                    onError: { [weak self] error in
                        guard let `self` = self else { return }
                        self.loadingVariable.value = false
                        self.errorStringVariable.value = error.localizedDescription
                })
                .disposed(by: disposeBag)
        }
        
    }
}

extension ActivityViewModel: ActivityViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var loading: Observable<Bool> {
        return loadingVariable.asObservable()
    }
    
    var shouldNotifySaveSuccess: Observable<Bool> {
        return notifySaveSuccessVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}

