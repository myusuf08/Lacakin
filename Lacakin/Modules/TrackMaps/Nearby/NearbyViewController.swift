//  
//  NearbyViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 11/03/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

class NearbyViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var indexExpand = 10000
    var delegate: NearbyDelegate?
    var viewModel: NearbyViewModel!
    var coordinator: NearbyCoordinator!

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

extension NearbyViewController {
    
    func setupViews() {
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(NearbyTableViewCell.self)
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

extension NearbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.listNearbyModel?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.listNearbyModel?.data?[indexPath.row]
        let cell = tableView.dequeueClass(NearbyTableViewCell.self)
        cell.configure(model: model)
        cell.locationDidTap = {
            self.delegate?.didNearbyLocationSelected(index: indexPath.row)
        }
        cell.callDidTap = {
            guard let number = URL(string: "tel://" + "\(model?.phone ?? "")") else { return }
            UIApplication.shared.open(number)
        }
        cell.messageDidTap = {
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = ""
                controller.recipients = [model?.phone ?? ""]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }
        if indexExpand == indexPath.row {
            cell.separatorViewTop.isHidden = true
            cell.separatorViewBottom.isHidden = false
            cell.callButton.isHidden = false
            cell.messageButton.isHidden = false
            cell.locationButton.isHidden = false
        } else {
            cell.separatorViewTop.isHidden = false
            cell.separatorViewBottom.isHidden = true
            cell.callButton.isHidden = true
            cell.messageButton.isHidden = true
            cell.locationButton.isHidden = true
        }
        return cell
    }
}

extension NearbyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexExpand = indexPath.row
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexExpand == indexPath.row {
            return 100
        } else {
            return 60
        }
    }
}

extension NearbyViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}

protocol NearbyDelegate {
    func didNearbyLocationSelected(index: Int)
}
