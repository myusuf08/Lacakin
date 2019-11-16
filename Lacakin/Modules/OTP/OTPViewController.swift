//  
//  OTPViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class OTPViewController: BaseViewController {

    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    
    var viewModel: OTPViewModel!
    var coordinator: OTPCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        //viewModel.inputs.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: Private

extension OTPViewController {
    
    func setupViews() {
        view1.layer.cornerRadius = 8
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.defaultBlue.cgColor
        
        view2.layer.cornerRadius = 8
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.defaultBlue.cgColor
        
        view3.layer.cornerRadius = 8
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.defaultBlue.cgColor
        
        view4.layer.cornerRadius = 8
        view4.layer.borderWidth = 1
        view4.layer.borderColor = UIColor.defaultBlue.cgColor
        
        view5.layer.cornerRadius = 8
        view5.layer.borderWidth = 1
        view5.layer.borderColor = UIColor.defaultBlue.cgColor
        
        sendButton.layer.cornerRadius = 8
        
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(resend), for: .touchUpInside)
        
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        
        textField1.keyboardType = .numberPad
        textField2.keyboardType = .numberPad
        textField3.keyboardType = .numberPad
        textField4.keyboardType = .numberPad
        textField5.keyboardType = .numberPad
        
        viewModel.onViewDidLoad()
    }
    
    func bindViewModel() {
        observeOTPSuccess()
        observeTextField1()
        observeTextField2()
        observeTextField3()
        observeTextField4()
        observeTextField5()
        observeError()
        observeOTPChangePhoneSuccess()
        observeOTPFailed()
    }
    
    func observeOTPFailed() {
        viewModel.outputs.shouldNotifyOTPFailed
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func observeOTPSuccess() {
        viewModel.outputs.shouldNotifyOTPSuccess
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func observeOTPChangePhoneSuccess() {
        viewModel.outputs.shouldNotifyOTPChangePhoneSuccess
            .subscribe(onNext: { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func observeTextField1() {
        textField1.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onText1Changed(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeTextField2() {
        textField2.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onText2Changed(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeTextField3() {
        textField3.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onText3Changed(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeTextField4() {
        textField4.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onText4Changed(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeTextField5() {
        textField5.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onText5Changed(text)
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
}

extension OTPViewController {
    @objc func send() {
        self.viewModel.inputs.confirmOTP()
    }
    
    @objc func resend() {
        viewModel.onViewDidLoad()
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !(string == "") {
            textField.text = string
            if textField == textField1 {
                textField2.becomeFirstResponder()
            } else if textField == textField2 {
                textField3.becomeFirstResponder()
            } else if textField == textField3 {
                textField4.becomeFirstResponder()
            } else if textField == textField4 {
                textField5.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.count ?? 0) > 0 {
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
