//  
//  NearbyViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

protocol NearbyViewModelType {
    var inputs: NearbyViewModelInputs { get }
    var outputs: NearbyViewModelOutputs { get }
}

protocol NearbyViewModelInputs {
    func onViewDidLoad()
}

protocol NearbyViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var listNearbyModel: ListNearbyData? { get }
    var code: String { get }
}

class NearbyViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var NearbyModel: NearbyModel?
    var listNearbyModel: ListNearbyData?
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

extension NearbyViewModel {
    
}

extension NearbyViewModel: NearbyViewModelType {
    var inputs: NearbyViewModelInputs { return self }
    var outputs: NearbyViewModelOutputs { return self }
}

extension NearbyViewModel: NearbyViewModelInputs {
    
    func onViewDidLoad() {
        lat = locationManager.location?.coordinate.latitude ?? -6.21462
        lng = locationManager.location?.coordinate.longitude ?? 106.84513
        getListNearby()
        
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
                        self.listNearbyModel = response
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
}

extension NearbyViewModel: NearbyViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
