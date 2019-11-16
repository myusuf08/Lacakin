//  
//  DetailForgotPasswordViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/05/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol DetailForgotPasswordViewModelType {
    var inputs: DetailForgotPasswordViewModelInputs { get }
    var outputs: DetailForgotPasswordViewModelOutputs { get }
}

protocol DetailForgotPasswordViewModelInputs {
    func onViewDidLoad()
    func onPasswordChanged(_ text: String)
    func onConfirmPasswordChanged(_ text: String)
    func onCodeChanged(_ text: String)
    func send()
}

protocol DetailForgotPasswordViewModelOutputs {
    var update: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var notifySuccessNewPass: Observable<Bool> { get }
}

class DetailForgotPasswordViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    private let notifySuccessNewPassVariable = Variable<Bool>(false)
    var DetailForgotPasswordModel: DetailForgotPasswordModel?
    private var password = ""
    private var confirmPassword = ""
    private var code = ""
    var phone = ""
    
    init(phone: String) {
        super.init()
        self.phone = phone
    }
}

// MARK: Private

extension DetailForgotPasswordViewModel {
    
}

extension DetailForgotPasswordViewModel: DetailForgotPasswordViewModelType {
    var inputs: DetailForgotPasswordViewModelInputs { return self }
    var outputs: DetailForgotPasswordViewModelOutputs { return self }
}

extension DetailForgotPasswordViewModel: DetailForgotPasswordViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func onPasswordChanged(_ text: String) {
        password = text
    }
    
    func onConfirmPasswordChanged(_ text: String) {
        confirmPassword = text
    }
    
    func onCodeChanged(_ text: String) {
        code = text
    }
    
    func send() {
        if password.isEmpty {
            errorStringVariable.value = "Password must be filled"
            return
        } else if password.count < 4 {
            errorStringVariable.value = "Password less than 4 characters"
            return
        } else if confirmPassword.isEmpty {
            errorStringVariable.value = "Confirm password must be filled"
            return
        } else if confirmPassword.count < 4 {
            errorStringVariable.value = "Confirm password less than 4 characters"
            return
        } else if password != confirmPassword {
            errorStringVariable.value = "Password not match"
            return
        } else if code.count < 5 {
            errorStringVariable.value = "Invalid OTP Code"
            return
        }
        lacakinApiProvider.rx
            .request(.newPassword(NewPasswordRequest(phone: phone, password: password, code: code)))
            .mapObject(NewPasswordData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.notifySuccessNewPassVariable.value = true
                        User.shared.clearUserData()
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
        
    }
}

extension DetailForgotPasswordViewModel: DetailForgotPasswordViewModelOutputs {
    var notifySuccessNewPass: Observable<Bool> {
        return notifySuccessNewPassVariable.asObservable().filter { $0 != false}.map{ $0 }
    }
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
