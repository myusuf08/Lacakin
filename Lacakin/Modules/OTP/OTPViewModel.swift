//  
//  OTPViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol OTPViewModelType {
    var inputs: OTPViewModelInputs { get }
    var outputs: OTPViewModelOutputs { get }
}

protocol OTPViewModelInputs {
    func onViewDidLoad()
    func confirmOTP()
    func onText1Changed(_ text: String)
    func onText2Changed(_ text: String)
    func onText3Changed(_ text: String)
    func onText4Changed(_ text: String)
    func onText5Changed(_ text: String)
}

protocol OTPViewModelOutputs {
    var update: Observable<Bool> { get }
    var shouldNotifyOTPSuccess: Observable<Bool> { get }
    var shouldNotifyOTPChangePhoneSuccess: Observable<Bool> { get }
    var shouldNotifyOTPFailed: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    
}

class OTPViewModel: BaseViewModel {

    var text1 = ""
    var text2 = ""
    var text3 = ""
    var text4 = ""
    var text5 = ""
    var phone: String?
    private let updateVariable = Variable<Bool>(false)
    private let notifyOTPSuccessVariable = Variable<Bool>(false)
    private let notifyOTPChangePhoneSuccessVariable = Variable<Bool>(false)
    private let notifyOTPFailedVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    var OTPModel: OTPModel?
    var isOTPChangePhone = false
    
    init(phone: String, isOTPChangePhone: Bool) {
        super.init()
        self.phone = phone
        self.isOTPChangePhone = isOTPChangePhone
    }
}

// MARK: Private

extension OTPViewModel {
    
}

extension OTPViewModel: OTPViewModelType {
    var inputs: OTPViewModelInputs { return self }
    var outputs: OTPViewModelOutputs { return self }
}

extension OTPViewModel: OTPViewModelInputs {
    
    func onViewDidLoad() {
        if !isOTPChangePhone {
            requestOTP()
        }
    }
    
    func requestOTP() {
        lacakinApiProvider.rx
            .request(.requestOTP(RequestOTPRequest(phone: phone)))
            .mapObject(RequestOTPData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = response.message ?? ""
                    if response.status ?? 0 > 200 {
                        if self.isOTPChangePhone {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.notifyOTPFailedVariable.value = true
                            })
                            
                        }
                        return
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func onText1Changed(_ text: String) {
        text1 = text
    }
    
    func onText2Changed(_ text: String) {
        text2 = text
    }
    
    func onText3Changed(_ text: String) {
        text3 = text
    }
    
    func onText4Changed(_ text: String) {
        text4 = text
    }
    
    func onText5Changed(_ text: String) {
        text5 = text
    }
    
    func confirmOTP() {
        if text1.isEmpty {
            errorStringVariable.value = "Invalid OTP Code"
            return
        }
        if text2.isEmpty {
            errorStringVariable.value = "Invalid OTP Code"
            return
        }
        if text3.isEmpty {
            errorStringVariable.value = "Invalid OTP Code"
            return
        }
        if text4.isEmpty {
            errorStringVariable.value = "Invalid OTP Code"
            return
        }
        if text5.isEmpty {
            errorStringVariable.value = "Invalid OTP Code"
            return
        }
        let code = "\(text1)\(text2)\(text3)\(text4)\(text5)"
        if isOTPChangePhone {
            requestSendOTPChangePhone(phone: self.phone ?? "", code: code)
        } else {
            requestSendOTP(phone: self.phone ?? "", code: code)
        }
    }
    
    func requestSendOTP(phone: String, code: String) {
        lacakinApiProvider.rx
            .request(.confirmOTP(ConfirmOTPRequest(phone: phone, code: code)))
            .mapObject(ConfirmOTPData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.notifyOTPSuccessVariable.value = true
                        })
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
                    
            })
            .disposed(by: disposeBag)
    }
    
    func requestSendOTPChangePhone(phone: String, code: String) {
        lacakinApiProvider.rx
            .request(.setOTPPhone(SetOTPPhoneRequest(phone: phone, code: code)))
            .mapObject(SetOTPPhoneData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        User.shared.profile?.phone = phone
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.notifyOTPChangePhoneSuccessVariable.value = true
                            NotificationCenter.default.post(name: Notification.Name("updatePhoneNumber"), object: nil, userInfo: nil)
                        })
                        
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
                    
            })
            .disposed(by: disposeBag)
    }
}

extension OTPViewModel: OTPViewModelOutputs {
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var shouldNotifyOTPSuccess: Observable<Bool> {
        return notifyOTPSuccessVariable.asObservable().filter { $0 }
    }
    
    var shouldNotifyOTPChangePhoneSuccess: Observable<Bool> {
        return notifyOTPChangePhoneSuccessVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var shouldNotifyOTPFailed: Observable<Bool> {
        return notifyOTPFailedVariable.asObservable().filter { $0 }
    }
}
