//  
//  TrackMapsViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 03/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

protocol TrackMapsViewModelType {
    var inputs: TrackMapsViewModelInputs { get }
    var outputs: TrackMapsViewModelOutputs { get }
}

protocol TrackMapsViewModelInputs {
    func onViewDidLoad()
    func startTracking()
    func stopTracking()
}

protocol TrackMapsViewModelOutputs {
    var notifyTrackStop: Observable<Bool> { get }
    var notifyTrackStart: Observable<Bool> { get }
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var listRouteModel: Observable<ListRouteData?> { get }
    var listCheckpointModel: Observable<ListCheckpointData?> { get }
    var listNearbyModel: Observable<ListNearbyData?> { get }
    var listRouteModels: ListRouteData? { get }
    var listCheckpointModels: ListCheckpointData? { get }
    var listNearbyModels: ListNearbyData? { get }
    var code: String { get }
}

class TrackMapsViewModel: BaseViewModel {

    private let notifyTrackStopVariable = Variable<Bool>(false)
    private let notifyTrackStartVariable = Variable<Bool>(false)
    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var listRouteModelVariable = Variable<ListRouteData?>(nil)
    var listCheckpointModelVariable = Variable<ListCheckpointData?>(nil)
    var listNearbyModelVariable = Variable<ListNearbyData?>(nil)
    var listRouteModels: ListRouteData?
    var listCheckpointModels: ListCheckpointData?
    var listNearbyModels: ListNearbyData?
    var TrackMapsModel: TrackMapsModel?
    var locationManager = CLLocationManager()
    var code = ""
    var lat = -6.21462
    var lng = 106.84513
    var trackId = 0
    
    init(code: String) {
        super.init()
        self.code = code
    }
}

// MARK: Private

extension TrackMapsViewModel {
    
}

extension TrackMapsViewModel: TrackMapsViewModelType {
    var inputs: TrackMapsViewModelInputs { return self }
    var outputs: TrackMapsViewModelOutputs { return self }
}

extension TrackMapsViewModel: TrackMapsViewModelInputs {
    
    func onViewDidLoad() {
        lat = locationManager.location?.coordinate.latitude ?? -6.21462
        lng = locationManager.location?.coordinate.longitude ?? 106.84513
        getListRoute()
        getListCheckpoint()
        getListNearby()
    }
    
    func startTracking() {
        lacakinApiProvider.rx
            .request(.startTracking(StartTrackingRequest(actcode: code)))
            .mapObject(StartTrackingData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.trackId = response.data.tackingid ?? 0
                        self.notifyTrackStartVariable.value = true
                        User.shared.isTracking = true
                        User.shared.isCodeTracking = self.code
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
    
    func stopTracking() {
        lacakinApiProvider.rx
            .request(.stopTracking(StopTrackingRequest(actcode: code, trkid: "\(trackId)", desc: "")))
            .mapObject(StopTrackingData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        
                        self.notifyTrackStopVariable.value = true
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.notifyTrackStopVariable.value = true
                        User.shared.isTracking = false
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    
                    self.notifyTrackStopVariable.value = true
                    // self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func getListRoute() {
        lacakinApiProvider.rx
            .request(.listRoute(ListRouteRequest(code: code)))
            .mapObject(ListRouteData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.listRouteModelVariable.value = response
                        self.listRouteModels = response
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
                        self.listCheckpointModelVariable.value = response
                        self.listCheckpointModels = response
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
    
    func getListNearby() {
        lacakinApiProvider.rx
            .request(.listNearby(ListNearbyRequest(code: code, lat: "\(lat)", long: "\(lng)")))
            .mapObject(ListNearbyData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        // self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        self.listNearbyModelVariable.value = response
                        self.listNearbyModels = response
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

extension TrackMapsViewModel: TrackMapsViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var notifyTrackStart: Observable<Bool> {
        return notifyTrackStartVariable.asObservable().filter { $0 != false }.map { $0 }
    }
    
    var notifyTrackStop: Observable<Bool> {
        return notifyTrackStopVariable.asObservable().filter { $0 != false }.map { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var listRouteModel: Observable<ListRouteData?> {
        return listRouteModelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var listCheckpointModel: Observable<ListCheckpointData?> {
        return listCheckpointModelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
    
    var listNearbyModel: Observable<ListNearbyData?> {
        return listNearbyModelVariable.asObservable().filter { $0 != nil }.map { $0 }
    }
}
