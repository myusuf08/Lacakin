//  
//  ForgotPasswordViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol ForgotPasswordViewModelType {
    var inputs: ForgotPasswordViewModelInputs { get }
    var outputs: ForgotPasswordViewModelOutputs { get }
}

protocol ForgotPasswordViewModelInputs {
    func onViewDidLoad()
    func onPhoneChanged(_ text: String)
}

protocol ForgotPasswordViewModelOutputs {
    var update: Observable<Bool> { get }
    var shouldNotifyForgotSuccess: Observable<String> { get }
    var errorString: Observable<String> { get }
}

class ForgotPasswordViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    var ForgotPasswordModel: ForgotPasswordModel?
    private let notifyForgotSuccessVariable = Variable<String>("")
    private let errorStringVariable = Variable<String>("")
    var phone = ""
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension ForgotPasswordViewModel {
    
}

extension ForgotPasswordViewModel: ForgotPasswordViewModelType {
    var inputs: ForgotPasswordViewModelInputs { return self }
    var outputs: ForgotPasswordViewModelOutputs { return self }
}

extension ForgotPasswordViewModel: ForgotPasswordViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func onPhoneChanged(_ text: String) {
        phone = text
    }
    
    func didTapResetButton() {
        if !"0\(phone)".isValidPhoneNumber {
            errorStringVariable.value = "Invalid phone number"
            return
        }
        let phones = "62\(phone)"
        lacakinApiProvider.rx
            .request(.resetPassword(ResetPasswordRequest(phone: phones)))
            .mapObject(ResetPasswordData.self)
            .do(onSuccess: { response in
                User.shared.token = response.data.token
                User.shared.header = response.data.token
            })
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.notifyForgotSuccessVariable.value = phones
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension ForgotPasswordViewModel: ForgotPasswordViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var shouldNotifyForgotSuccess: Observable<String> {
        return notifyForgotSuccessVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
