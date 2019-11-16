//  
//  CheckpointViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation


protocol CheckpointViewModelType {
    var inputs: CheckpointViewModelInputs { get }
    var outputs: CheckpointViewModelOutputs { get }
}

protocol CheckpointViewModelInputs {
    func onViewDidLoad()
    func checkinCheckpoint(cpId: Int)
}

protocol CheckpointViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var listCheckpointModels: ListCheckpointData? { get }
    var notifySuccessCheckin: Observable<Bool> { get }
    var code: String { get }
}

class CheckpointViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    private let notifySuccessCheckinVariable = Variable<Bool>(false)
    var CheckpointModel: CheckpointModel?
    var listCheckpointModels: ListCheckpointData?
    var locationManager = CLLocationManager()
    var code = ""
    var lat = -6.21462
    var lng = 106.84513
    
    init(code: String) {
        super.init()
        self.code = code
    }
}

// MARK: Private

extension CheckpointViewModel {
    
}

extension CheckpointViewModel: CheckpointViewModelType {
    var inputs: CheckpointViewModelInputs { return self }
    var outputs: CheckpointViewModelOutputs { return self }
}

extension CheckpointViewModel: CheckpointViewModelInputs {
    
    func onViewDidLoad() {
        lat = locationManager.location?.coordinate.latitude ?? -6.21462
        lng = locationManager.location?.coordinate.longitude ?? 106.84513
        getListCheckpoint()
    }
    
    func getListCheckpoint() {
        lacakinApiProvider.rx
            .request(.listCheckpoint(ListCheckpointRequest(code: code)))
            .mapObject(ListCheckpointData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.listCheckpointModels = response
                        self.updateVariable.value = true
                        // self.loadingVariable.value = false
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    // self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func checkinCheckpoint(cpId: Int) {
        lacakinApiProvider.rx
            .request(.checkinCheckpoint(CheckinCheckpointRequest(cpid: cpId, actcode: code, lat: "\(lat)", long: "\(lng)", tz: "Asia/Jakarta", tm: Int(Date().timeIntervalSince1970))))
            .mapObject(CheckinCheckpointData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.notifySuccessCheckinVariable.value = true
                        // self.loadingVariable.value = false
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    // self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
}

extension CheckpointViewModel: CheckpointViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var notifySuccessCheckin: Observable<Bool> {
        return notifySuccessCheckinVariable.asObservable().filter { $0 != false }.map{ $0 }
    }
}
