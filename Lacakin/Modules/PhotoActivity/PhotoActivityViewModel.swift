//  
//  PhotoActivityViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol PhotoActivityViewModelType {
    var inputs: PhotoActivityViewModelInputs { get }
    var outputs: PhotoActivityViewModelOutputs { get }
}

protocol PhotoActivityViewModelInputs {
    func onViewDidLoad()
    func onViewDidAppear()
    func deletePhoto(photoId: String)
}

protocol PhotoActivityViewModelOutputs {
    var update: Observable<Bool> { get }
    var loading: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var model: [ListPhotoActivityResponse]? { get }
}

class PhotoActivityViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var PhotoActivityModel: PhotoActivityModel?
    var model: [ListPhotoActivityResponse]? = []
    private let loadingVariable = Variable<Bool>(false)
    var actId = ""
    var title = ""
    
    init(actId: String, model: [ListPhotoActivityResponse]?) {
        super.init()
        self.actId = actId
        self.model = model
    }
}

// MARK: Private

extension PhotoActivityViewModel {
    
}

extension PhotoActivityViewModel: PhotoActivityViewModelType {
    var inputs: PhotoActivityViewModelInputs { return self }
    var outputs: PhotoActivityViewModelOutputs { return self }
}

extension PhotoActivityViewModel: PhotoActivityViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func onViewDidAppear() {
        getListPhotoActivity()
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
                        //self.loadingVariable.value = false
                        return
                    }
                    if response.status == 200 {
                        //self.loadingVariable.value = false
                        self.model = response.data
                        self.updateVariable.value = true
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    //self.loadingVariable.value = false
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func deletePhoto(photoId: String) {
        lacakinApiProvider.rx
            .request(.deletePhotoActivity(DeletePhotoActivityRequest(actid: actId, photoid: photoId)))
            .mapObject(DeletePhotoActivityData.self)
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
                        self.errorStringVariable.value = response.message ?? ""
                        self.getListPhotoActivity()
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

extension PhotoActivityViewModel: PhotoActivityViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var loading: Observable<Bool> {
        return loadingVariable.asObservable()
    }
}
