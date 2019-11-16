//  
//  EditProfileViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

class EditProfileViewController: BaseViewController {

    var window: UIWindow?
    @IBOutlet weak var changePasswordViewGesture: UIView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var oldPassView: UIView!
    @IBOutlet weak var oldPassTextField: UITextField!
    @IBOutlet weak var oldPasswordButton: UIButton!
    @IBOutlet weak var oldPasswordImageView: UIImageView!
    @IBOutlet weak var newPassView: UIView!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var newPasswordButton: UIButton!
    @IBOutlet weak var newPasswordImageView: UIImageView!
    @IBOutlet weak var confirmPassView: UIView!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    @IBOutlet weak var sendChangePasswordButton: UIButton!
    //
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var maleGenderButton: UIButton!
    @IBOutlet weak var womanGenderButton: UIButton!
    @IBOutlet weak var maleGenderImage: UIImageView!
    @IBOutlet weak var womanGenderImage: UIImageView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var setBirtdayButton: UIButton!
    @IBOutlet weak var descYourSelfTextView: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var editUsernameButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var editEmailButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var editPhoneButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var viewModel: EditProfileViewModel!
    var coordinator: EditProfileCoordinator!
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    var datePicker: UIDatePicker?
    var toolBar: UIToolbar?
    let picker = UIImagePickerController()
    var imagesProfile: UIImage? = nil
    var oldPasswordShow = false
    var newPasswordShow = false
    var confirmPasswordShow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Private

extension EditProfileViewController {
    
    func setupViews() {
        picker.delegate = self
        addLeftBackButton(#selector(back))
        addDefaultTitleNav(title: "Edit Profile")
        addEmptyBarButton(isRight: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        changePasswordViewGesture.addGestureRecognizer(tap)
        updateButton.addTarget(self, action: #selector(update), for: .touchUpInside)
        setBirtdayButton.addTarget(self, action: #selector(setBirthday), for: .touchUpInside)
        womanGenderButton.addTarget(self, action: #selector(setGenderWoman), for: .touchUpInside)
        maleGenderButton.addTarget(self, action: #selector(setGenderMan), for: .touchUpInside)
        editUsernameButton.addTarget(self, action: #selector(editUsername), for: .touchUpInside)
        editEmailButton.addTarget(self, action: #selector(editEmail), for: .touchUpInside)
        editPhoneButton.addTarget(self, action: #selector(editPhone), for: .touchUpInside)
        changePasswordButton.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        userImageButton.addTarget(self, action: #selector(changeImageProfile), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        sendChangePasswordButton.addTarget(self, action: #selector(changePasswordRequest), for: .touchUpInside)
        oldPasswordButton.addTarget(self, action: #selector(oldPasswordChange), for: .touchUpInside)
        newPasswordButton.addTarget(self, action: #selector(newPasswordChange), for: .touchUpInside)
        confirmPasswordButton.addTarget(self, action: #selector(confirmPasswordChange), for: .touchUpInside)
        initProfile()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updatePhoneNumber),
            name: NSNotification.Name(rawValue: "updatePhoneNumber"),
            object: nil)
    }
    
    func initProfile() {
        // PROFILE
        profileView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        accountView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        let profile = User.shared.profile
        nameTextField.text = profile?.fullname
        if profile?.sex == nil {
            maleGenderImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
            womanGenderImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
        } else if profile?.sex == "M" {
            maleGenderImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
            womanGenderImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
        } else if profile?.sex == "F" {
            maleGenderImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
            womanGenderImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
        }
        maleGenderImage.tintColor = .defaultBlue
        womanGenderImage.tintColor = .defaultBlue
        let date = Date(timeIntervalSince1970: Double(profile?.birth ?? 0))
        birthdayLabel.text = date.dateToString()
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: date)
        let sendDateFormatter = DateFormatter()
        sendDateFormatter.dateFormat = "yyyy-MM-dd"
        let sendDateString = sendDateFormatter.string(from: date)
        viewModel.inputs.setBirthdayParams(date: sendDateString)
        viewModel.inputs.setBirthday(date: dateString)
        
        if profile?.bio == "" || profile?.bio == nil {
            descYourSelfTextView.text = "Describe yourself"
            descYourSelfTextView.textColor = UIColor.lightGray
        } else {
            descYourSelfTextView.text = profile?.bio
        }
        descYourSelfTextView.delegate = self
        let url = URL(string: profile?.photoUrl ?? "")
        userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        // ACCOUNT
        usernameTextField.text = profile?.username
        emailTextField.text = profile?.email
        let phone = profile?.phone?.replacingOccurrences(of: "62", with: "") ?? ""
        phoneTextField.text = phone
        passwordTextField.text = "******"
        usernameTextField.isEnabled = false
        emailTextField.isEnabled = false
        phoneTextField.isEnabled = false
        passwordTextField.isEnabled = false
        viewModel.setFullname(text: profile?.fullname ?? "")
        viewModel.setUsername(text: profile?.username ?? "")
        viewModel.setEmail(text: profile?.email ?? "")
        viewModel.setPhone(text: profile?.phone ?? "")
        viewModel.setDescription(text: profile?.bio ?? "")
        viewModel.setGender(text: profile?.sex ?? "")
    }
    func bindViewModel() {
        observeLoading()
        observeUpdate()
        observeError()
        observerButton()
        observerTextField()
        observeLogoutSuccess()
    }
    
    func observeLoading() {
        viewModel.outputs.loading
            .subscribe(onNext: { [weak self] loading in
                if loading {
                    self?.activityIndicatorBegin()
                } else {
                    self?.activityIndicatorEnd()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observerTextField() {
        usernameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setUsername(text: text)
            })
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setFullname(text: text)
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setEmail(text: text)
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setEmail(text: text)
            })
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setEmail(text: text)
            })
            .disposed(by: disposeBag)
        
        descYourSelfTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setDescription(text: text)
            })
            .disposed(by: disposeBag)
        
        oldPassTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setOldPassword(text: text)
            })
            .disposed(by: disposeBag)
        
        newPassTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setPassword(text: text)
            })
            .disposed(by: disposeBag)
        
        confirmPassTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.setConfirmPassword(text: text)
            })
            .disposed(by: disposeBag)
        
        phoneTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                if text.count > 4 && text.count < 6 {
                    let first = String(text.prefix(1))
                    if first == "0" {
                        self.phoneTextField.text = String(text.dropFirst())
                    }
                }
                self.viewModel.inputs.setPhone(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
            })
            .disposed(by: disposeBag)
    }
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
            })
            .disposed(by: disposeBag)
    }
    
    func observerButton() {
        viewModel.outputs.usernameString
            .subscribe(onNext: { [unowned self] text in
                self.editUsernameButton.setTitle(text, for: .normal)
                if text == "save" {
                    self.editUsernameButton.setTitleColor(.defaultBlue, for: .normal)
                    self.usernameTextField.isEnabled = true
                } else {
                    self.editUsernameButton.setTitleColor(.defaultRed, for: .normal)
                    self.usernameTextField.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.emailString
            .subscribe(onNext: { [unowned self] text in
                self.editEmailButton.setTitle(text, for: .normal)
                if text == "save" {
                    self.editEmailButton.setTitleColor(.defaultBlue, for: .normal)
                    self.emailTextField.isEnabled = true
                } else {
                    self.editEmailButton.setTitleColor(.defaultRed, for: .normal)
                    self.emailTextField.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.phoneDefault
            .subscribe(onNext: { [unowned self] text in
                self.editPhoneButton.setTitle("edit", for: .normal)
                self.editPhoneButton.setTitleColor(.defaultRed, for: .normal)
                self.phoneTextField.isEnabled = false
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.phoneString
            .subscribe(onNext: { [unowned self] text in
                if text == "save" {
                    self.editPhoneButton.setTitleColor(.defaultBlue, for: .normal)
                    self.phoneTextField.isEnabled = true
                    self.editPhoneButton.setTitle("save", for: .normal)
                } else {
                    let phone = "62\(self.phoneTextField.text ?? "")"
                    let vc = OTPCoordinator.createOTPViewController(phone: phone, isOTPChangePhone: true)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.passwordViewHiddenStatus
            .subscribe(onNext: { [unowned self] status in
                self.changePasswordView.isHidden = !status
            })
            .disposed(by: disposeBag)
    }
    
    func observeLogoutSuccess() {
        viewModel.outputs.logoutSuccess
            .subscribe(onNext: { [weak self] _  in
                User.shared.token = nil
                let loginViewController = LoginCoordinator.createLoginViewController()
                let nav = UINavigationController(rootViewController: loginViewController)
                nav.isNavigationBarHidden = true
                self?.window = UIWindow(frame: UIScreen.main.bounds)
                self?.window?.rootViewController = nav
                self?.window?.makeKeyAndVisible()
            })
            .disposed(by: disposeBag)
    }
}

extension EditProfileViewController {
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func logout() {
        viewModel.inputs.logout()
    }
    
    @objc func update() {
        viewModel.inputs.updateProfile()
    }
    
    @objc func editUsername() {
        viewModel.inputs.editUsernameStatus()
    }
    
    @objc func editEmail() {
        viewModel.inputs.editEmailStatus()
    }
    
    @objc func editPhone() {
        viewModel.inputs.editPhoneStatus()
    }
    
    @objc func changePassword() {
        viewModel.inputs.setPasswordViewStatus(bool: true)
    }
    
    @objc func changePasswordRequest() {
        viewModel.inputs.updatePassword()
    }
    
    @objc func handleTap() {
        viewModel.inputs.setPasswordViewStatus(bool: false)
    }
    
    @objc func send() {
        viewModel.inputs.updatePassword()
    }
    
    @objc func setBirthday() {
        doDatePicker()
    }
    
    @objc func setGenderMan() {
        maleGenderImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
        womanGenderImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
        viewModel.setGender(text: "M")
    }
    
    @objc func setGenderWoman() {
        maleGenderImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
        womanGenderImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
        viewModel.setGender(text: "F")
    }
    
    func doDatePicker() {
        // DatePicker
        view.endEditing(true)
        if datePicker != nil {
            datePicker?.removeFromSuperview()
        }
        datePicker = UIDatePicker()
        let screenSize = UIScreen.main.bounds
        datePicker? = UIDatePicker(frame:CGRect(x: 0, y: screenSize.height - 200, width: screenSize.width, height: 200))
        datePicker?.backgroundColor = UIColor.white
        datePicker?.datePickerMode = UIDatePicker.Mode.date
        view.addSubview(datePicker!)
        
        // ToolBar
        if toolBar != nil {
            toolBar?.removeFromSuperview()
        }
        toolBar = UIToolbar()
        toolBar?.barStyle = .default
        toolBar?.frame = CGRect(x: 0,y: screenSize.height - 246, width:screenSize.width,height: 46)
        toolBar?.isTranslucent = true
        toolBar?.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar?.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar?.isUserInteractionEnabled = true
        view.addSubview(toolBar!)
        toolBar?.isHidden = false
        
    }
    
    @objc func donePicker() {
        datePicker?.removeFromSuperview()
        toolBar?.removeFromSuperview()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: datePicker?.date ?? Date())
        let sendDateFormatter = DateFormatter()
        sendDateFormatter.dateFormat = "yyyy-MM-dd"
        let sendDateString = sendDateFormatter.string(from: datePicker?.date ?? Date())
        viewModel.inputs.setBirthdayParams(date: sendDateString)
        viewModel.inputs.setBirthday(date: dateString)
        birthdayLabel.text = dateString
    }
    
    @objc func cancelClick() {
        datePicker?.removeFromSuperview()
        toolBar?.removeFromSuperview()
    }
    
    @objc func changeImageProfile() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadPhoto() {
        if let image = imagesProfile {
            self.activityIndicatorBegin(false)
            let imgData = image.jpegData(compressionQuality: 0.75) ?? Data()
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "photo",fileName: "\(User.shared.profile?.username ?? "")_\(Date().dateToStringUpload()).jpg", mimeType: "image/jpg")
            }, to: "\(String.BaseApiUrl)/user/set/pic", method: .post, headers: ["x-access-token":User.shared.header ?? ""]) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.activityIndicatorEnd()
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            let gtfw = JSON["gtfwResult"] as! [String: Any]
                            let data = gtfw["data"] as! [String: Any]
                            let url = data["photo_url"] as! String
                            User.shared.profile?.photoUrl = url
                            self.userImageView.image = image
                        }
                        
                        
                    }
                case .failure(let encodingError):
                    self.activityIndicatorEnd()
                    print("error upload =\(encodingError.localizedDescription)")
                }
            }
        }
        
    }
    
    @objc func oldPasswordChange() {
        if oldPasswordShow {
            oldPasswordShow = false
            oldPasswordImageView.image = ImageConstant.eyeGreyHide
            oldPassTextField.isSecureTextEntry = !oldPasswordShow
        } else {
            oldPasswordShow = true
            oldPasswordImageView.image = ImageConstant.eyeGreyShow
            oldPassTextField.isSecureTextEntry = !oldPasswordShow
        }
    }
    
    @objc func newPasswordChange() {
        if newPasswordShow {
            newPasswordShow = false
            newPasswordImageView.image = ImageConstant.eyeGreyHide
            newPassTextField.isSecureTextEntry = !newPasswordShow
        } else {
            newPasswordShow = true
            newPasswordImageView.image = ImageConstant.eyeGreyShow
            newPassTextField.isSecureTextEntry = !newPasswordShow
        }
    }
    
    @objc func confirmPasswordChange() {
        if confirmPasswordShow {
            confirmPasswordShow = false
            confirmPasswordImageView.image = ImageConstant.eyeGreyHide
            confirmPassTextField.isSecureTextEntry = !confirmPasswordShow
        } else {
            confirmPasswordShow = true
            confirmPasswordImageView.image = ImageConstant.eyeGreyShow
            confirmPassTextField.isSecureTextEntry = !confirmPasswordShow
        }
    }
    
    @objc private func updatePhoneNumber(notification: NSNotification) {
        self.editPhoneButton.setTitle("edit", for: .normal)
        self.editPhoneButton.setTitleColor(.defaultRed, for: .normal)
        self.phoneTextField.isEnabled = false
        let profile = User.shared.profile
        viewModel.setPhone(text: profile?.phone ?? "")
        viewModel.inputs.setIsPhoneEditing(bool: false)
    }
}

extension EditProfileViewController: UINavigationControllerDelegate {
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imagesProfile = image
            self.uploadPhoto()
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}


extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = "Describe yourself"
        textView.textColor = UIColor.lightGray
    }
}
