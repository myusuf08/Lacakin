//  
//  ForgotPasswordViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var phoneView: UIView!
    
    var viewModel: ForgotPasswordViewModel!
    var coordinator: ForgotPasswordCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension ForgotPasswordViewController {
    
    func setupViews() {
        phoneView.layer.cornerRadius = 12
        phoneView.layer.borderColor = UIColor.defaultBlue.cgColor
        phoneView.layer.borderWidth = 1
        resetPasswordButton.layer.cornerRadius = 12
        countryImage.image = ImageConstant.indonesia
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        resetPasswordButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
        phoneTextField.attributedPlaceholder =
            NSAttributedString(string: "Input your phone",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func bindViewModel() {
        observeUpdate()
        observePhone()
        observeError()
        observeForgotSuccess()
    }
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
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
    
    func observePhone() {
        phoneTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                if text.count > 4 && text.count < 6{
                    let first = String(text.prefix(1))
                    if first == "0" {
                        self.phoneTextField.text = String(text.dropFirst())
                    }
                }
                self.viewModel.inputs.onPhoneChanged(text)
                
            })
            .disposed(by: disposeBag)
    }
    
    func observeForgotSuccess() {
        viewModel.outputs.shouldNotifyForgotSuccess
            .subscribe(onNext: { phone in
                let vc = DetailForgotPasswordCoordinator.createDetailForgotPasswordViewController(phone: phone)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension ForgotPasswordViewController {
    @objc func reset() {
        viewModel.didTapResetButton()
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}
