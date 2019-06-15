//  
//  DetailForgotPasswordViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/05/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class DetailForgotPasswordViewController: BaseViewController {

    var viewModel: DetailForgotPasswordViewModel!
    var coordinator: DetailForgotPasswordCoordinator!

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordImage: UIImageView!
    
    var isPasswordShow = false
    var isConfirmPasswordShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension DetailForgotPasswordViewController {
    
    func setupViews() {
        
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.defaultBlue.cgColor
        passwordView.layer.cornerRadius = 12
        passwordImage.image = ImageConstant.eyeGreyHide
        passwordButton.addTarget(self, action: #selector(passwordShowHide),
                                 for: .touchUpInside)
        
        confirmPasswordView.layer.borderWidth = 1
        confirmPasswordView.layer.borderColor = UIColor.defaultBlue.cgColor
        confirmPasswordView.layer.cornerRadius = 12
        confirmPasswordImage.image = ImageConstant.eyeGreyHide
        confirmPasswordButton.addTarget(self, action: #selector(confirmPasswordShowHide),
                                 for: .touchUpInside)
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
        observerSuccess()
        observePassword()
        observeConfirmPassword()
        observeCode()
    }
    
    func observePassword() {
        passwordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onPasswordChanged(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeConfirmPassword() {
        confirmPasswordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onConfirmPasswordChanged(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeCode() {
        codeTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onCodeChanged(text)
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
    
    func observerSuccess() {
        viewModel.outputs.notifySuccessNewPass
            .subscribe(onNext: { [unowned self] _ in
                let alert = UIAlertController(title: nil, message: "Your account and password has been successfully verified and updated. Please login to your account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "LOGIN NOW", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        self.navigationController?.popToRootViewController(animated: true)
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func passwordShowHide() {
        if isPasswordShow {
            isPasswordShow = false
            passwordImage.image = ImageConstant.eyeGreyHide
            passwordTextField.isSecureTextEntry = !isPasswordShow
        } else {
            isPasswordShow = true
            passwordImage.image = ImageConstant.eyeGreyShow
            passwordTextField.isSecureTextEntry = !isPasswordShow
        }
    }
    
    @objc func confirmPasswordShowHide() {
        if isConfirmPasswordShow {
            isConfirmPasswordShow = false
            confirmPasswordImage.image = ImageConstant.eyeGreyHide
            confirmPasswordTextField.isSecureTextEntry = !isConfirmPasswordShow
        } else {
            isConfirmPasswordShow = true
            confirmPasswordImage.image = ImageConstant.eyeGreyShow
            confirmPasswordTextField.isSecureTextEntry = !isConfirmPasswordShow
        }
    }
    
    @objc func send() {
        viewModel.inputs.send()
    }
}
