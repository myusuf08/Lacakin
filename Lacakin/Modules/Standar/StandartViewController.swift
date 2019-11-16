//  
//  StandartViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class StandartViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: StandartViewModel!
    var coordinator: StandartCoordinator!
    var helpItem = ["Apakah bisa mengundang teman untuk bergabung di aktivitas kita?","Apakah fungsi privacy Controls?","Apakah bisa mengundang teman untuk bergabung di aktivitas kita?","Bagaimana cara join aktivitas?","Bagaimana cara approve permintaan join aktivitas","Bagaimana cara membuat rute?","Bagaimana cara menambah Checkpoint?","Bagaimana cara memulai dan mengakhiri tracking?","Bagaimana cara Check in di Checkpoint?","Bagaimana cara mengunggah foto?"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension StandartViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 999
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.registerNib(StandartTableViewCell.self)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeTitleNav()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
            })
            .disposed(by: disposeBag)
    }
    
    func observeTitleNav() {
        viewModel.outputs.title
            .subscribe(onNext: { [weak self] titleNav in
                self?.addLeftBackButton(#selector(self?.back))
                self?.addDefaultTitleNav(title: titleNav)
                self?.addEmptyBarButton(isRight: true)
            })
            .disposed(by: disposeBag)
    }
}

extension StandartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueClass(StandartTableViewCell.self)
        cell.configure(desc: helpItem[indexPath.row])
        return cell
    }
}


extension StandartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension StandartViewController {
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}
