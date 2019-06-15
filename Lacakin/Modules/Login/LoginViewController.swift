//  
//  LoginViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 30/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import KYDrawerController
import GoogleSignIn

class LoginViewController: BaseViewController {
    
    var window: UIWindow?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var emailUsernameImageView: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailUsernameButton: UIButton!
    @IBOutlet weak var emailUsernameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginGoogleButton: UIButton!
    
    var isPasswordShow = false
    var viewModel: LoginViewModel!
    var coordinator: LoginCoordinator!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension LoginViewController {
    
    func setupViews() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        setupBlurEffect()
        countryImage.image = ImageConstant.indonesia
        phoneImageView.image = ImageConstant.dotSelected
        emailUsernameImageView.image = ImageConstant.dotUnselected
        emailUsernameView.isHidden = true
        passwordImage.image = ImageConstant.eyeHide
        
        phoneView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        phoneView.layer.cornerRadius = 12
        emailUsernameView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        emailUsernameView.layer.cornerRadius = 12
        passwordView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        passwordView.layer.cornerRadius = 12
        loginButton.layer.cornerRadius = 12
        loginGoogleButton.layer.cornerRadius = 12
        
        passwordTextField.attributedPlaceholder =
            NSAttributedString(string: "Type your password",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameTextField.attributedPlaceholder =
            NSAttributedString(string: "Type your Username or Email",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneTextField.attributedPlaceholder =
            NSAttributedString(string: "Input your phone",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Bold", size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Metropolis-Regular", size: 12.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributedString1 = NSMutableAttributedString(string:"Don't have an account? ", attributes:attrs2)
        let attributedString2 = NSMutableAttributedString(string:"Sign up.", attributes:attrs1)
        attributedString1.append(attributedString2)
        signupLabel.attributedText = attributedString1
        
        phoneButton.addTarget(self, action: #selector(phoneSelected),
                              for: .touchUpInside)
        emailUsernameButton.addTarget(self, action: #selector(usernameSelected),
                                      for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signup),
                               for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotpassword),
                                       for: .touchUpInside)
        passwordButton.addTarget(self, action: #selector(passwordShowHide),
                                 for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginGoogleButton.addTarget(self, action: #selector(loginGoogle), for: .touchUpInside)
        
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
        observeUsernameEmail()
        observePhone()
        observePassword()
        observeLoginSuccess()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
            })
            .disposed(by: disposeBag)
    }
    
    func observeUsernameEmail() {
        usernameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onUsernameEmailChanged(text)
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
    
    func observeLoginSuccess() {
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
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    @objc func phoneSelected() {
        viewModel.inputs.isUsernameEmail(false)
        phoneImageView.image = ImageConstant.dotSelected
        emailUsernameImageView.image = ImageConstant.dotUnselected
        emailUsernameView.isHidden = true
        phoneView.isHidden = false
    }
    
    @objc func usernameSelected() {
        viewModel.inputs.isUsernameEmail(true)
        phoneImageView.image = ImageConstant.dotUnselected
        emailUsernameImageView.image = ImageConstant.dotSelected
        emailUsernameView.isHidden = false
        phoneView.isHidden = true
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
    
    @objc func signup() {
        let vc = RegisterCoordinator.createRegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func forgotpassword() {
        let vc = ForgotPasswordCoordinator.createForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func login() {
        viewModel.inputs.onLoginButtonClicked()
    }
    
    @objc func loginGoogle() {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
}


extension LoginViewController: GIDSignInUIDelegate {
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


extension LoginViewController: GIDSignInDelegate {
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
