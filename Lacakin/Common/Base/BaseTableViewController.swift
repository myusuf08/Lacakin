//
//  BaseTableView.swift
//  CIRCLMVVM
//
//  Created by Muhammad Yusuf on 02/11/18.
//  Copyright © 2018 Muhammad Yusuf. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .collectionViewBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .collectionViewBackground
        registerClass(EmptyTableViewCell.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: Public

extension BaseTableViewController {
    func dequeueBasicTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(
            withIdentifier: "UITableViewCell",
            for: indexPath)
    }
    
    func registerNib<T: UITableViewCell>(_ type: T.Type) where T: ReusableView {
        tableView.registerNib(T.self)
    }
    
    func registerClass<T: UITableViewCell>(_ type: T.Type) where T: ReusableView {
        tableView.registerClass(T.self)
    }
}

// MARK: UITableViewDataSource

extension BaseTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            return tableView.dequeueCell(forIndexPath: indexPath) as EmptyTableViewCell
    }
}

// MARK: UITableViewDelegate

extension BaseTableViewController: UITableViewDelegate {
    
}
