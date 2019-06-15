//  
//  AddRouteViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import RxSwift
import MobileCoreServices
import Alamofire

class AddRouteViewController: BaseViewController, UIDocumentPickerDelegate {

    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var openFileButton: UIButton!
    
    var viewModel: AddRouteViewModel!
    var coordinator: AddRouteCoordinator!
    var actCode = ""

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
        setupViews()
        bindViewModel()
        viewModel.inputs.onViewDidLoad()
    }
}

// MARK: Private

extension AddRouteViewController {
    
    func setupViews() {
        addLeftBackButton(#selector(back))
        addDefaultTitleNav(title: "Add Route")
        addEmptyBarButton(isRight: true)
        importButton.addTarget(self, action: #selector(importStrava), for: .touchUpInside)
        openFileButton.addTarget(self, action: #selector(openFile), for: .touchUpInside)
    }
    
    func bindViewModel() {
        observeUpdate()
        observeError()
    }
    
    func observeUpdate() {
        viewModel.outputs.update
            .subscribe(onNext: { [weak self] _ in
                // doing update
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
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func importStrava() {
        let vc = WKWebViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openFile() {
//        let arr = ["public.content", "public.item","public.composite-content","public.data","public.database","public.calendar-event","public.message","public.presentation","public.contact","public.archive","public.disk-image","public.text","public.plain-text","public.utf8-plain-text","public.utf16-external-plain-​text","public.utf16-plain-text","com.apple.traditional-mac-​plain-text","public.rtf"];
        //["public.kmz","public.kml","public.gpx","public.txt"]
        let controller = UIDocumentPickerViewController(
            documentTypes: ["public.item"], // choose your desired documents the user is allowed to select
            in: .import // choose your desired UIDocumentPickerMode
        )
        controller.delegate = self
        if #available(iOS 11.0, *) {
            controller.allowsMultipleSelection = false
        }
        present(controller,animated: true,completion: nil)
    }
    
    @available(iOS 11.0, *)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // do something with the selected documents
        if let url = urls.first {
            do {
                let urlString = url.absoluteString
                let data = try Data(contentsOf: url as URL)
                checkingString(string: urlString, dataFile: data)
                print("urlString = \(urlString)")
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // do something with the selected document
        do {
            let urlString = url.absoluteString
            let data = try Data(contentsOf: url as URL)
            checkingString(string: urlString, dataFile: data)
            print("urlString = \(urlString)")
        } catch {
            print("Unable to load data: \(error)")
        }
    }

    func checkingString(string: String, dataFile: Data) {
        let last3 = String(string.suffix(3))
        if last3 == "kml" || last3 == "kmz" || last3 == "gpx" {
            self.activityIndicatorBegin(false)
            let parameters = ["replacecp": "0", "replaceroute": "0", "actcode": actCode] //Optional for extra parameter
            Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(dataFile, withName: "route",fileName: "route_\(Date().dateToStringUpload()).\(last3)", mimeType: "file")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters
            }, to: "\(String.BaseApiUrl)/import/route", method: .post, headers: ["x-access-token":User.shared.header ?? ""]) { (result) in
                switch result {
                case .success(let upload, _, _):
                    self.activityIndicatorEnd()
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        if let result = response.result.value {
                            let JSON = result as! NSDictionary
                            print("result = \(result)")
                            print("result JSON = \(JSON)")
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let encodingError):
                    self.activityIndicatorEnd()
                    print("error upload =\(encodingError.localizedDescription)")
                }
            }
        } else {
            ToastView.show(message: "Wrong file format", in: self, length: .short)
            return
        }
    }
}
