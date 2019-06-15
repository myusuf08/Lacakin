//  
//  ProfileViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 13/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class ProfileViewController: BaseViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tabView: TabView!
    
    var viewModel: ProfileViewModel!
    var coordinator: ProfileCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension ProfileViewController {
    
    func setupViews() {
        
    }
    
    func bindViewModel() {
        observeUpdate()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
            })
            .disposed(by: disposeBag)
    }
}
