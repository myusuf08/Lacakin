//  
//  OthersViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class OthersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var viewModel: OthersViewModel!
    var coordinator: OthersCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension OthersViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.registerNib(OthersTableViewCell.self)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] status in
                if status == false {
                    self?.tableView.isHidden = !status
                    self?.emptyLabel.isHidden = status
                } else {
                    self?.tableView.isHidden = !status
                    self?.tableView.reloadData()
                }
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

extension OthersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.inputs.getActivityListOthersData()?.data?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueClass(OthersTableViewCell.self)
        guard let model = viewModel.inputs.getActivityListOthersData()?.data?[indexPath.row] else { return cell }
        cell.configureOthers(model: model)
        return cell
    }
}


extension OthersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.inputs.getActivityListOthersData()?.data?[indexPath.row] else { return }
        let emptyModel = ActivityListResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actPublic: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil, actLocation:nil, photos: [])
        let vc = DetailActivityCoordinator.createDetailActivityViewController(activityModel: emptyModel, activityModelOthers: model, isFromList: false, joinActivityCode: "", isFromFriend: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //224
        return UITableView.automaticDimension
    }
}
