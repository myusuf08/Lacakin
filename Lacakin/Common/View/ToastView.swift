//
//  ToastView.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/02/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import Foundation
import UIKit

enum ToastViewDuration {
    case short
    case long
    
    static var secondLong = 4.0
    static var secondShort = 2.0
}

final class ToastView: UIView {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regular()
        label.textColor = .white
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    var secondToastViewShow: ToastViewDuration = .short
    
}

// MARK: Private

private extension ToastView {
    func setToastView(message: String,
                      view: ToastView,
                      viewController: UIViewController) {
        let screenSize = UIScreen.main.bounds
        let messageWidth: CGFloat = message.width(withConstrainedHeight: 40,
                                                  font: UIFont.regular()) + 30
        let messageHeight: CGFloat = message.height(withConstrainedWidth: messageWidth, font: UIFont.regular()) + 30
        
        if messageWidth > screenSize.width {
            
            view.roundCorner(radius: 5, clip: true)
            view.frame = CGRect(x: 15,
                                y: screenSize.height,
                                width: screenSize.width - 30,
                                height: messageHeight)
        } else {
            
            view.roundCorner(radius: 20, clip: true)
            view.frame = CGRect(x: (screenSize.width / 2) - messageWidth / 2,
                                y: screenSize.height,
                                width: messageWidth,
                                height: 40)
        }
        
        view.backgroundColor = .shadowBold
        messageLabel.frame = CGRect(x: 10,
                                    y: 0,
                                    width: view.frame.size.width - 20,
                                    height: view.frame.size.height)
        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        viewController.view.addSubview(view)
        viewController.view.bringSubviewToFront(view)
    }
    
    func removeToastView(view: ToastView,
                         length: ToastViewDuration) {
        switch length {
        case .long:
            DispatchQueue.main.asyncAfter(
                deadline: .now() + ToastViewDuration.secondLong,
                execute: {
                    view.removeFromSuperview()
            })
        case .short:
            DispatchQueue.main.asyncAfter(
                deadline: .now() + ToastViewDuration.secondShort,
                execute: {
                    view.removeFromSuperview()
            })
        }
    }
    
    func animatedToastView(message: String,
                           view: ToastView) {
        UIView.animate(withDuration: 0.15) {
            let screenSize = UIScreen.main.bounds
            let messageWidth: CGFloat = message.width(withConstrainedHeight: 40,
                                                      font: UIFont.regular()) + 30
            let messageHeight: CGFloat = message.height(withConstrainedWidth: messageWidth, font: UIFont.regular()) + 30
            
            if messageWidth > screenSize.width {
                view.frame = CGRect(x: 15,
                                    y: screenSize.height - (screenSize.height) * 0.2,
                                    width: screenSize.width - 30,
                                    height: messageHeight)
            } else {
                
                view.frame = CGRect(x: (screenSize.width / 2) - messageWidth / 2,
                                    y: screenSize.height - (screenSize.height) * 0.2,
                                    width: messageWidth,
                                    height: 40)
            }
        }
    }
}

// MARK: Public

extension ToastView {
    static func show(message: String,
                     in viewController: UIViewController,
                     length: ToastViewDuration) {
        let view = ToastView()
        for views in viewController.view.subviews where views is ToastView {
            let views = views as! ToastView
            views.isHidden = true
        }
        view.setToastView(message: message, view: view, viewController: viewController)
        view.animatedToastView(message: message, view: view)
        view.removeToastView(view: view, length: length)
    }
}
