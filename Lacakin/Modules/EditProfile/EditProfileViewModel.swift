//  
//  EditProfileViewModel.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import RxSwift

protocol EditProfileViewModelType {
    var inputs: EditProfileViewModelInputs { get }
    var outputs: EditProfileViewModelOutputs { get }
}

protocol EditProfileViewModelInputs {
    func onViewDidLoad()
    func setPasswordViewStatus(bool: Bool)
    func editUsernameStatus()
    func editEmailStatus()
    func editPhoneStatus()
    func setUsername(text: String)
    func setFullname(text: String)
    func setEmail(text: String)
    func setPhone(text: String)
    func setOldPassword(text: String)
    func setPassword(text: String)
    func setConfirmPassword(text: String)
    func setDescription(text: String)
    func setBirthday(date: String)
    func setBirthdayParams(date: String)
    func setGender(text: String)
    func updateProfile()
    func updateUsername()
    func updateEmail()
    func updatePhone()
    func updatePassword()
    func logout()
    func setIsPhoneEditing(bool: Bool)
}

protocol EditProfileViewModelOutputs {
    var update: Observable<Bool> { get }
    var loading: Observable<Bool> { get }
    var errorString: Observable<String> { get }
    var usernameString: Observable<String> { get }
    var emailString: Observable<String> { get }
    var phoneString: Observable<String> { get }
    var logoutSuccess: Observable<Bool> { get }
    var passwordViewHiddenStatus: Observable<Bool> { get }
    var phoneDefault: Observable<Bool> { get }
}

class EditProfileViewModel: BaseViewModel {

    private let updateVariable = Variable<Bool>(false)
    private let loadingVariable = Variable<Bool>(false)
    private let errorStringVariable = Variable<String>("")
    private let usernameButtonVariable = Variable<String>("")
    private let emailButtonVariable = Variable<String>("")
    private let phoneButtonVariable = Variable<String>("")
    private let passwordViewHiddenVariable = Variable<Bool>(false)
    private let logoutSuccessVariable = Variable<Bool>(false)
    private let phoneDefaultVariable = Variable<Bool>(false)
    var EditProfileModel: EditProfileModel?
    var oldPassword = ""
    var confirmPassword = ""
    var password = ""
    var phone = ""
    var email = ""
    var username = ""
    var fullname = ""
    var gender = ""
    var birthday = ""
    var birthdayParams = ""
    var desc = ""
    var isUsernameEditing = false
    var isEmailEditing = false
    var isPhoneEditing = false
    var isChangePassword = false
    
    override init() {
        super.init()
    }
}

// MARK: Private

extension EditProfileViewModel {
    
}

extension EditProfileViewModel: EditProfileViewModelType {
    var inputs: EditProfileViewModelInputs { return self }
    var outputs: EditProfileViewModelOutputs { return self }
}

extension EditProfileViewModel: EditProfileViewModelInputs {
    
    func onViewDidLoad() {
        
    }
    
    func setIsPhoneEditing(bool: Bool) {
        isPhoneEditing = bool
    }
    func setPasswordViewStatus(bool: Bool) {
        passwordViewHiddenVariable.value = bool
    }
    
    func editUsernameStatus() {
        if isUsernameEditing {
            updateUsername()
        } else {
            usernameButtonVariable.value = "save"
            isUsernameEditing = true
        }
    }
    
    func editEmailStatus() {
        if isEmailEditing {
            updateEmail()
        } else {
            emailButtonVariable.value = "save"
            isEmailEditing = true
        }
    }
    
    func editPhoneStatus() {
        if isPhoneEditing {
            updatePhone()
        } else {
            phoneButtonVariable.value = "save"
            isPhoneEditing = true
        }
    }
    
    func setFullname(text: String) {
        fullname = text
    }
    
    func setUsername(text: String) {
        username = text
    }
    
    func setEmail(text: String) {
        email = text
    }
    
    func setPhone(text: String) {
        phone = text
    }
    
    func setOldPassword(text: String) {
        oldPassword = text
    }
    
    func setPassword(text: String) {
        password = text
    }
    
    func setConfirmPassword(text: String) {
        confirmPassword = text
    }
    
    func setDescription(text: String) {
        desc = text
    }
    
    func setBirthday(date: String) { //dd MMM yyyy.
        birthday = date
    }
    
    func setBirthdayParams(date: String) { //yyyy-MM-dd.
        birthdayParams = date
    }
    
    func setGender(text: String) { // M untuk laki-laki, dan F untuk perempuan.
        gender = text
    }
    
    func updateProfile() {
        if fullname.isEmpty {
            errorStringVariable.value = "Name must be filled"
            return
        }
        if gender.isEmpty {
            errorStringVariable.value = "Gender must be filled"
            return
        }
        if birthdayParams.isEmpty {
            errorStringVariable.value = "Birthday must be filled"
            return
        }
        lacakinApiProvider.rx
            .request(.updateProfile(UpdateProfileRequest(fullname: fullname, sex: gender, birthday: birthdayParams, bio: desc)))
            .mapObject(UpdateProfileData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        let dates = dateFormatter.date(from: self.birthday)
                        // convert Date to TimeInterval (typealias for Double)
                        let timeInterval = dates?.timeIntervalSince1970
                        // convert to Integer
                        let dateInt = Int(timeInterval ?? 0)
                        User.shared.profile?.fullname = self.fullname
                        User.shared.profile?.bio = self.desc
                        User.shared.profile?.sex = self.gender
                        User.shared.profile?.birth = dateInt
                        self.errorStringVariable.value = response.message ?? ""
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func updateUsername() {
        if username.isEmpty {
            errorStringVariable.value = "Username must be filled"
            return
        }
        lacakinApiProvider.rx
            .request(.setUsername(SetUsernameRequest(username: username)))
            .mapObject(SetUsernameData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        User.shared.profile?.username = self.username
                        self.usernameButtonVariable.value = "edit"
                        self.isUsernameEditing = false
                        self.errorStringVariable.value = response.message ?? ""
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func updateEmail() {
        if !email.isValidEmail {
            errorStringVariable.value = "Invalid email"
            return
        }
        lacakinApiProvider.rx
            .request(.setEmail(SetEmailRequest(email: email)))
            .mapObject(SetEmailData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        User.shared.profile?.email = self.email
                        self.errorStringVariable.value = response.message ?? ""
                        self.emailButtonVariable.value = "edit"
                        self.isEmailEditing = false
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func updatePhone() {
        if !"0\(phone)".isValidPhoneNumber {
            errorStringVariable.value = "Invalid phone number"
            return
        }
        let phoneNumber = "62\(phone)"
        let userPhone = User.shared.profile?.phone ?? ""
        if phoneNumber == userPhone {
            phoneDefaultVariable.value = true
            isPhoneEditing = false
            return
        }
        lacakinApiProvider.rx
            .request(.setPhone(SetPhoneRequest(phone: phoneNumber)))
            .mapObject(SetPhoneData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        self.phoneButtonVariable.value = "edit"
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func updatePassword() {
        if oldPassword != User.shared.userPassword {
            self.errorStringVariable.value = "Old password wrong"
            return
        }
        if password.count < 4 {
            self.errorStringVariable.value = "Password less than 4 characters"
            return
        }
        if password != confirmPassword {
            self.errorStringVariable.value = "Password not match"
            return
        }
        lacakinApiProvider.rx
            .request(.setPassword(SetPasswordRequest(oldPassword: oldPassword,password: password)))
            .mapObject(SetPasswordData.self)
            .do(onSuccess: { response in
                if response.status == 200 {
                    User.shared.token = response.data.token
                    User.shared.header = response.data.token
                }
            })
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    if response.status ?? 0 > 200 {
                        self.errorStringVariable.value = response.message ?? ""
                        return
                    }
                    if response.status == 200 {
                        User.shared.userPassword = self.password
                        self.errorStringVariable.value = response.message ?? ""
                        self.passwordViewHiddenVariable.value = false
                    }
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.errorStringVariable.value = error.localizedDescription
            })
            .disposed(by: disposeBag)
    }
    
    func logout() {
        loadingVariable.value = true
        lacakinApiProvider.rx
            .request(.logout(LogoutRequest()))
            .mapObject(LogoutData.self)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let `self` = self else { return }
                    self.logoutSuccessVariable.value = true
                    self.loadingVariable.value = false
                },
                onError: { [weak self] error in
                    guard let `self` = self else { return }
                    self.logoutSuccessVariable.value = true
                    self.loadingVariable.value = false
            })
            .disposed(by: disposeBag)
    }
}

extension EditProfileViewModel: EditProfileViewModelOutputs {
    var passwordViewHiddenStatus: Observable<Bool> {
        return passwordViewHiddenVariable.asObservable()
    }
    
    var usernameString: Observable<String> {
        return usernameButtonVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var emailString: Observable<String> {
        return emailButtonVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var phoneString: Observable<String> {
        return phoneButtonVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var phoneDefault: Observable<Bool> {
        return phoneDefaultVariable.asObservable().filter { $0 }
    }
    
    var update: Observable<Bool> {
        return updateVariable.asObservable().filter { $0 }
    }
    
    var errorString: Observable<String> {
        return errorStringVariable.asObservable().filter { $0 != "" }.map{ $0 }
    }
    
    var logoutSuccess: Observable<Bool> {
        return logoutSuccessVariable.asObservable().filter { $0 }
    }
    
    var loading: Observable<Bool> {
        return loadingVariable.asObservable()
    }
}
