//  
//  NotificationsViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher
import Realm
import RealmSwift

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NotificationsViewModel!
    var coordinator: NotificationsCoordinator!
    lazy var notifications: Results<MTQQNotificationRealm> = { self.realm.objects(MTQQNotificationRealm.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
        refreshData()
    }
    
    override func subscribeNotifDidSuccess() {
        tableView.reloadData()
        refreshData()
    }
}

// MARK: Private

extension NotificationsViewController {
    
    func setupViews() {
        addDefaultTitleNav(title: "Notification")
        addLeftBackButton(#selector(back))
        addEmptyBarButton(isRight: true)
        initTableView()
    }
    
    func refreshData() {
        let notificationModel = realm.objects(MTQQNotificationRealm.self)
        try! realm.write {
            for (index, item) in notificationModel.enumerated() {
                notifications[index].isRead = true
            }
        }
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(NotificationsTableViewCell.self)
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

extension NotificationsViewController {
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications.reversed()[indexPath.row]
        let cell = tableView.dequeueClass(NotificationsTableViewCell.self)
        cell.configure(model: model)
        return cell
    }
}

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
