//  
//  EventsViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 05/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class EventsViewController: BaseViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EventsViewModel!
    var coordinator: EventsCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension EventsViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        tableView.registerNib(EventsTableViewCell.self)
        tableView.isHidden = true
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
        
        viewModel.outputs.empty
            .subscribe(onNext: { [weak self] text in
                self?.emptyLabel.text = text
            })
            .disposed(by: disposeBag)
    }
}

extension EventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueClass(EventsTableViewCell.self)
        cell.configure()
        return cell
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
