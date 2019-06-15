//  
//  MineViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class MineViewController: BaseViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: MineViewModel!
    var coordinator: MineCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension MineViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.registerNib(MineTableViewCell.self)
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

extension MineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.inputs.getActivityListData()?.data?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueClass(MineTableViewCell.self)
        guard let model = viewModel.inputs.getActivityListData()?.data?[indexPath.row] else { return cell }
        cell.configure(model: model)
        return cell
    }
}


extension MineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.inputs.getActivityListData()?.data?[indexPath.row] else { return }
        let emptyModel = ActivityListOthersResponse.init(actId: nil, actCode: nil, actName: nil, actDesc: nil, actDateTimeStart: nil, actTimezone: nil, actCreated: nil, actComments: nil, actUserid: nil, actLikes: nil, actIslike: nil, actmemActive: nil, actmemDate: nil, ownerId: nil, ownerName: nil, ownerPhoto: nil, photos: [])
        let vc = DetailActivityCoordinator.createDetailActivityViewController(activityModel: model, activityModelOthers: emptyModel, isFromList: true, joinActivityCode: "", isFromFriend: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //224
        return UITableView.automaticDimension
    }
}
