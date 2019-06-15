//  
//  LoginViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift
import GoogleSignIn

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

protocol LoginViewModelInputs {
    func onViewDidLoad()
    func onUsernameEmailChanged(_ text: String)
    func onPhoneChanged(_ text: String)
    func onPasswordChanged(_ text: String)
    func onLoginButtonClicked()
    func isUsernameEmail(_ bool: Bool)
    func loginGoogle(gtoken: String)
}

protocol LoginViewModelOutputs {
    var update: Observable<Bool> { get }
    var shouldNotifyLoginSuccess: Observable<Bool> { get }
    var errorString: Observable<String> { get }
}

class LoginViewModel: BaseViewModel {

    private var usernameEmail = ""
    private var phone = ""
    private var password = ""
    private let updateVariable = Variable<Bool>(false)
    private let notifyLoginSuccessVariable = Variable<Bool>(false)
    let errorStringVariable = Variable<String>("")
    var LoginModel: LoginModel?
    private var isUsernameEmail = false
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension LoginViewModel {
    
}

extension LoginViewModel: LoginViewModelType {
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }
}

extension LoginViewModel: LoginViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func isUsernameEmail(_ bool: Bool) {
        isUsernameEmail = bool
    }
    
    func onPhoneChanged(_ text: String) {
        phone = text
    }
    
    func onUsernameEmailChanged(_ text: String) {
        usernameEmail = text
    }
    
    func onPasswordChanged(_ text: String) {
        password = text
    }
    
    func onLoginButtonClicked() {
        if isUsernameEmail {
            if !usernameEmail.isValidEmail {
                errorStringVariable.value = "Invalid username or email"
                return
            }
        } else {
            if !"0\(phone)".isValidPhoneNumber {
                errorStringVariable.value = "Invalid phone number"
                return
            }
        }
        if password.isEmpty {
            errorStringVariable.value =  "Password must be filled"
            return
        } else if password.count < 4 {
            errorStringVariable.value = "Password less than 4 characters"
            return
        }
        var userId = ""
        if isUsernameEmail {
            userId = usernameEmail
        } else {
            userId = "62\(phone)"
        }
        
        lacakinApiProvider.rx
            .request(.login(LoginRequest(userid: userId,password: password)))
            .mapObject(LoginData.self)
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

extension LoginViewModel: LoginViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var shouldNotifyLoginSuccess: Observable<Bool> {
        return notifyLoginSuccessVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
}
