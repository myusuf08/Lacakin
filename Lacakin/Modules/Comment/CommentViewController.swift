//  
//  CommentViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 21/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import GrowingTextView

class CommentViewController: BaseViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var heightViewConstraint: NSLayoutConstraint!
    var viewModel: CommentViewModel!
    var coordinator: CommentCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

// MARK: Private

extension CommentViewController {
    
    func setupViews() {
        initTableView()
        addDefaultTitleNav(title: "Comment")
        addEmptyBarButton(isRight: true)
        addLeftBackButton(#selector(back))
        automaticallyAdjustsScrollViewInsets = false
        textView.layer.cornerRadius = 4.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    @objc func send() {
        textView.resignFirstResponder()
        textView.text = ""
        viewModel.inputs.commentActivity()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNib(UserCommentTableViewCell.self)
        tableView.registerNib(FriendCommentTableViewCell.self)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
        observeCommentText()
    }
    
    func observeCommentText() {
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] text in
                self.viewModel.inputs.onMessageText(text: text)
            })
            .disposed(by: disposeBag)
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

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.outputs.model?[indexPath.row]
        if model?.actcomUserid == User.shared.profile?.userId {
            let cell = tableView.dequeueClass(UserCommentTableViewCell.self)
            cell.configure(model: model)
            return cell
        } else {
            let cell = tableView.dequeueClass(FriendCommentTableViewCell.self)
            cell.configure(model: model)
            return cell
        }
    }
}

extension CommentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
