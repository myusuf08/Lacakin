//  
//  RouteViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps

class RouteViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var delegate: RouteDelegate?
    
    var viewModel: RouteViewModel!
    var coordinator: RouteCoordinator!

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

extension RouteViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(RouteTableViewCell.self)
    }
    
    func bindViewModel() {
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
    
    func observeError() {
        viewModel.outputs.errorString
            .subscribe(onNext: { [unowned self] error in
                ToastView.show(message: error, in: self, length: .short)
            })
            .disposed(by: disposeBag)
    }
}

extension RouteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.routeModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.routeModel?[indexPath.row]
        let cell = tableView.dequeueClass(RouteTableViewCell.self)
        cell.configure(model: model)
        return cell
    }
}

extension RouteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didRouteSelected(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

protocol RouteDelegate {
    func didRouteSelected(index: Int)
}
