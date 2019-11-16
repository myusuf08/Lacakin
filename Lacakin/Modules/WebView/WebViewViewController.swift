//  
//  WebViewViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class WebViewViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webView: UIWebView!
    
    var viewModel: WebViewViewModel!
    var coordinator: WebViewCoordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension WebViewViewController {
    
    func setupViews() {
        webView.backgroundColor = .white
    }
    
    func bindViewModel() {
        observeUpdate()
        observeTitleNav()
        observeUrlWebView()
        observeTextView()
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
                guard let self = self else { return }
                self.addLeftBackButton(#selector(self.back))
                self.addDefaultTitleNav(title: titleNav)
                self.addEmptyBarButton(isRight: true)
            })
            .disposed(by: disposeBag)
    }
    
    func observeUrlWebView() {
        viewModel.outputs.url
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                self.webView.loadRequest(URLRequest(url: URL(string: url)!))
            })
            .disposed(by: disposeBag)
    }
    
    func observeTextView() {
        viewModel.outputs.text
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.textView.text = text
                self.webView.isHidden = true
                self.textView.setContentOffset(.zero, animated: false)
            })
            .disposed(by: disposeBag)
    }
}

extension WebViewViewController {
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}
