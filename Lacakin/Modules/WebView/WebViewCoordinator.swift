//  
//  WebViewCoordinator.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation

struct WebViewCoordinator {
    static func createWebViewViewController(title: String,
                                            url: String,
                                            _ isWebView: Bool = true) -> WebViewViewController {
        let controller = WebViewViewController()
        controller.viewModel = WebViewViewModel(title: title, url: url, isWebView: isWebView)
        controller.coordinator = WebViewCoordinator()
        return controller
    }
}

