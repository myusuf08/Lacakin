//  
//  SideMenuViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import KYDrawerController
import Kingfisher

class SideMenuViewController: BaseViewController {

    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var joinCodeButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var detailProfileButton: UIButton!
    
    var viewModel: SideMenuViewModel!
    var coordinator: SideMenuCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.onViewDidAppear()
    }
}

// MARK: Private

extension SideMenuViewController {
    
    func setupViews() {
        detailProfileButton.addTarget(self, action: #selector(detailProfile),
                                     for: .touchUpInside)
        joinCodeButton.addTarget(self, action: #selector(joinWithCode),
                                 for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(help),
                                 for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicy),
                             for: .touchUpInside)
        editProfileButton.addTarget(self, action: #selector(editProfile),
                                    for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: NSNotification.Name(rawValue: "updateprofilelacakin"), object: nil)
    }
    
    func bindViewModel() {
        observeUpdate()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] profile in
                guard let self = self else { return }
                let url = URL(string: profile?.photoUrl ?? "")
                self.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
                self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
                self.userImageView.clipsToBounds = true
                self.usernameLabel.text = profile?.fullname ?? ""
                self.userEmailLabel.text = profile?.email ?? ""
            })
            .disposed(by: disposeBag)
    }
    
    @objc func updateProfile() {
        let profile = User.shared.profile
        let url = URL(string: profile?.photoUrl ?? "")
        self.userImageView.kf.setImage(with: url, placeholder: UIImage(named: "common_avatar"))
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
        self.userImageView.clipsToBounds = true
        self.usernameLabel.text = profile?.fullname ?? ""
        self.userEmailLabel.text = profile?.email ?? ""
    }
}

extension SideMenuViewController {
    @objc func detailProfile() {
        guard let drawerController = parent as? KYDrawerController,
            let navController = drawerController.mainViewController as! UINavigationController?
            else { return }
        drawerController.setDrawerState(.closed, animated: true)
        // Push onto the stack
        let vc = DetailProfileCoordinator.createDetailProfileViewController(friendId: "", isUser: true)
        navController.pushViewController(vc, animated: true)
    }
    
    @objc func joinWithCode() {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
        NotificationManager.post(.showPopupCode)
    }
    
    @objc func help() {
        // Cast child controller of parent as UINavigationController
        guard let drawerController = parent as? KYDrawerController,
            let navController = drawerController.mainViewController as! UINavigationController?
            else { return }
        drawerController.setDrawerState(.closed, animated: true)
        // Push onto the stack
        let vc = StandartCoordinator.createStandartViewController(title: "Help")
        navController.pushViewController(vc, animated: true)
    }
    
    @objc func privacyPolicy() {
        // Cast child controller of parent as UINavigationController
        guard let drawerController = parent as? KYDrawerController,
            let navController = drawerController.mainViewController as! UINavigationController?
            else { return }
        drawerController.setDrawerState(.closed, animated: true)
        // Push onto the stack
        let vc = WebViewCoordinator.createWebViewViewController(title: "Privacy Policy", url: "", false)
        navController.pushViewController(vc, animated: true)
    }
    
    @objc func editProfile() {
        guard let drawerController = parent as? KYDrawerController,
            let navController = drawerController.mainViewController as! UINavigationController?
            else { return }
        drawerController.setDrawerState(.closed, animated: true)
        // Push onto the stack
        let vc = EditProfileCoordinator.createEditProfileViewController()
        navController.pushViewController(vc, animated: true)
    }
}
