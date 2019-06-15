//  
//  CheckpointViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class CheckpointViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CheckPointDelegate?
    var viewModel: CheckpointViewModel!
    var coordinator: CheckpointCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
        self.isNotificationOn = false
        self.isTrackOn = true
        self.codeAct = viewModel.outputs.code
    }
}

// MARK: Private

extension CheckpointViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(CheckpointTableViewCell.self)
    }
    
    func bindViewModel() {
        observeCheckinSuccess()
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func observeCheckinSuccess() {
        viewModel.outputs.notifySuccessCheckin
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didCheckinSelected(index: 0)
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

extension CheckpointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.listCheckpointModels?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.listCheckpointModels?.data?[indexPath.row]
        let cell = tableView.dequeueClass(CheckpointTableViewCell.self)
        cell.configure(model: model)
        cell.didSelectedDirection = {
            self.delegate?.didDirectionSelected(index: indexPath.row)
        }
        cell.didSelectedCheckin = {
            self.viewModel.inputs.checkinCheckpoint(cpId: model?.actcpId ?? 0)
        }
        return cell
    }
}

extension CheckpointViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didCheckpointSelected(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

protocol CheckPointDelegate {
    func didCheckpointSelected(index: Int)
    func didDirectionSelected(index: Int)
    func didCheckinSelected(index: Int)
}
