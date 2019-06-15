//
//  PopupCodeViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 19/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift

class PopupCodeViewController: BaseViewController {

    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var delegate: PopupCodeSuccessDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        codeTextField.layer.borderColor = UIColor.defaultBlue.cgColor
        codeTextField.layer.borderWidth = 2
        codeTextField.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 8
        bgView.layer.cornerRadius = 8
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(handleTap(sender:)))
        gestureView.addGestureRecognizer(tap)
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }

    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func submit() {
        if codeTextField.text?.count == 0 {
            ToastView.show(message: "Code tidak boleh kosong", in: self, length: .short)
            return
        }
        codeTextField.resignFirstResponder()
        self.dismiss(animated: false, completion: nil)
        self.delegate?.pushToDetailVC(code: self.codeTextField.text ?? "")
        
    }
    
    
}

protocol PopupCodeSuccessDelegate {
    func pushToDetailVC(code: String)
}
