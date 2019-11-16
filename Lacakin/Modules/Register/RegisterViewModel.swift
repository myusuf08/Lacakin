//  
//  RegisterViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol RegisterViewModelType {
    var inputs: RegisterViewModelInputs { get }
    var outputs: RegisterViewModelOutputs { get }
}

protocol RegisterViewModelInputs {
    func onViewDidLoad()
    func onNameChanged(_ text: String)
    func onPhoneChanged(_ text: String)
    func onPasswordChanged(_ text: String)
    func onRegisterButtonClicked()
    func loginGoogle(gtoken: String)
}

protocol RegisterViewModelOutputs {
    var update: Observable<Bool> { get }
    var shouldNotifyLoginSuccess: Observable<Bool> { get }
    var shouldNotifyRegisterSuccess: Observable<String> { get }
    var errorString: Observable<String> { get }
}

class RegisterViewModel: BaseViewModel {
    
    private var name = ""
    private var phone = ""
    private var password = ""
    private let updateVariable = Variable<Bool>(false)
    private let notifyLoginSuccessVariable = Variable<Bool>(false)
    private let notifyRegisterSuccessVariable = Variable<String>("")
    private let errorStringVariable = Variable<String>("")
    var RegisterModel: RegisterModel?
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension RegisterViewModel {
    
}

extension RegisterViewModel: RegisterViewModelType {
    var inputs: RegisterViewModelInputs { return self }
    var outputs: RegisterViewModelOutputs { return self }
}

extension RegisterViewModel: RegisterViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func onNameChanged(_ text: String) {
        name = text
    }
    
    func onPhoneChanged(_ text: String) {
        phone = text
    }
    
    func onPasswordChanged(_ text: String) {
        password = text
    }
    
    func onRegisterButtonClicked() {
        if name.isEmpty {
            errorStringVariable.value = "Name must be filled"
            return
        }
        if !"0\(phone)".isValidPhoneNumber {
            errorStringVariable.value = "Invalid phone number"
            return
        }
        if password.isEmpty {
            errorStringVariable.value = "Password must be filled"
            return
        } else if password.count < 4 {
            errorStringVariable.value = "Password less than 4 characters"
            return
        }
        var phoneNumber = ""
        phoneNumber = "62\(phone)"
        // 62895378143825 123456
        lacakinApiProvider.rx
            .request(.register(RegisterRequest(name: name,phone: phoneNumber, password: password, tz: "Jakarta")))
            .mapObject(LoginData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        User.shared.header = response.data.token
                        self.notifyRegisterSuccessVariable.value = phoneNumber
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
                    
            })
            .disposed(by: disposeBag)
    }
    
    func loginGoogle(gtoken: String) {
        lacakinApiProvider.rx
            .request(.loginGoogle(LoginGoogleRequest(gtoken: gtoken, tz: "Asia")))
            .mapObject(LoginGoogleData.self)
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
                        self.notifyLoginSuccessVariable.value = true
                        User.shared.profile = response.data
                        User.shared.userPassword = self.password
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
}

extension RegisterViewModel: RegisterViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var shouldNotifyRegisterSuccess: Observable<String> {
        return notifyRegisterSuccessVariable.asObservable().filter { $0 != "" }.map { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var shouldNotifyLoginSuccess: Observable<Bool> {
        return notifyLoginSuccessVariable.asObservable().filter { $0 }
    }
}
