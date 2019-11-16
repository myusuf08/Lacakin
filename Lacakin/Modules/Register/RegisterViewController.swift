//  
//  RegisterViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GoogleSignIn
import KYDrawerController

class RegisterViewController: BaseViewController {

    var window: UIWindow?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var regiterButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    var isPasswordShow = false
    var viewModel: RegisterViewModel!
    var coordinator: RegisterCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension RegisterViewController {
    
    func setupViews() {
        setupBlurEffect()
        countryImage.image = ImageConstant.indonesia
        phoneView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        phoneView.layer.cornerRadius = 12
        nameView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        nameView.layer.cornerRadius = 12
        passwordView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        passwordView.layer.cornerRadius = 12
        regiterButton.layer.cornerRadius = 12
        googleLoginButton.layer.cornerRadius = 12
        passwordImage.image = ImageConstant.eyeHide
        passwordButton.addTarget(self, action: #selector(passwordShowHide),
                                 for: .touchUpInside)
        passwordTextField.attributedPlaceholder =
            NSAttributedString(string: "Type your password",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nameTextField.attributedPlaceholder =
            NSAttributedString(string: "Type your name",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneTextField.attributedPlaceholder =
            NSAttributedString(string: "Input your phone",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Bold", size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Regular", size: 12.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributedString1 = NSMutableAttributedString(string:"Already have an account? ", attributes:attrs2)
        let attributedString2 = NSMutableAttributedString(string:"Login.", attributes:attrs1)
        attributedString1.append(attributedString2)
        loginLabel.attributedText = attributedString1
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        regiterButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        googleLoginButton.addTarget(self, action: #selector(loginGoogle), for: .touchUpInside)
    }
    
    func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.75
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeName()
        observePhone()
        observePassword()
        observeRegisterSuccess()
        observeError()
        observeLoginGoogleSuccess()
    }
    
    func observeLoginGoogleSuccess() {
        viewModel.outputs.shouldNotifyLoginSuccess
            .subscribe(onNext: { _ in
                let width = UIScreen.main.bounds.width - 50
                let mainViewController   = HomeCoordinator.createHomeViewController()
                let drawerViewController = SideMenuCoordinator.createSideMenuViewController()
                let drawerController     = KYDrawerController(drawerDirection: .left,
                                                              drawerWidth: width)
                drawerController.mainViewController = UINavigationController(
                    rootViewController: mainViewController
                )
                drawerController.drawerViewController = drawerViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = drawerController
                self.window?.makeKeyAndVisible()
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
    
    func observeName() {
        nameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onNameChanged(text)
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
    
    
    func observePassword() {
        passwordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onPasswordChanged(text)
            })
            .disposed(by: disposeBag)
    }
    
    func observeRegisterSuccess() {
        viewModel.outputs.shouldNotifyRegisterSuccess
            .subscribe(onNext: { [unowned self] phone in
                let vc = OTPCoordinator.createOTPViewController(phone: phone, isOTPChangePhone: false)
                self.navigationController?.pushViewController(vc, animated: true)
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

extension RegisterViewController {
    @objc func loginGoogle() {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func passwordShowHide() {
        if isPasswordShow {
            isPasswordShow = false
            passwordImage.image = ImageConstant.eyeHide
            passwordTextField.isSecureTextEntry = !isPasswordShow
        } else {
            isPasswordShow = true
            passwordImage.image = ImageConstant.eyeShow
            passwordTextField.isSecureTextEntry = !isPasswordShow
        }
    }
    
    @objc func login() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func register() {
        viewModel.inputs.onRegisterButtonClicked()
    }
}

extension RegisterViewController: GIDSignInUIDelegate {
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension RegisterViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            viewModel.inputs.loginGoogle(gtoken: idToken ?? "")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        ToastView.show(message: error.localizedDescription, in: self, length: .short)
    }
    
    
}
