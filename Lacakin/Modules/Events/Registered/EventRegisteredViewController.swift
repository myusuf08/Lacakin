//  
//  EventRegisteredViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class EventRegisteredViewController: BaseViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EventRegisteredViewModel!
    var coordinator: EventRegisteredCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension EventRegisteredViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(EventsTableViewCell.self)
        
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] bool in
                self?.tableView.reloadData()
                self?.tableView.isHidden = !bool
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.empty
            .subscribe(onNext: { [weak self] text in
                self?.emptyLabel.text = text
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


extension EventRegisteredViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.model?[indexPath.row]
        let cell = tableView.dequeueClass(EventsTableViewCell.self)
        guard let models = model else {
            return cell
        }
        cell.configureRegister(model: models)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension EventRegisteredViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.outputs.model?[indexPath.row]
        let vc = DetailEventCoordinator.createDetailEventViewController(eventId: "\(model?.eventId ?? 0)")
        navigationController?.pushViewController(vc, animated: true)
    }
}
