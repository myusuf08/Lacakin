//
//  WKWebViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class WKWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBackButton(#selector(back))
        addDefaultTitleNav(title: "STRAVA")
        webView.delegate = self
        let url = URL(string: "https://www.strava.com/login")!
        let requestObj = URLRequest(url: url)
        webView.loadRequest(requestObj)
        // Do any additional setup after loading the view.
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }

}

extension WKWebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        print("url scheme = \(request.url?.scheme ?? "")")
        print("url host = \(request.url?.host ?? "")")
        print("url request = \(request)")
        return true
    }
}
