//
//  UploadPhotoViewController.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 23/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Alamofire

class UploadPhotoViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var smallImageView: UIImageView!
    
    var image: UIImage = UIImage()
    var actId = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.clipsToBounds = true
        bgImageView.image = image
        smallImageView.contentMode = .scaleAspectFill
        smallImageView.clipsToBounds = true
        smallImageView.image = image
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(upload), for: .touchUpInside)
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func upload() {
        uploadPhoto(image: self.image)
    }
    
    func uploadPhoto(image: UIImage) {
        self.activityIndicatorBegin(false)
        let imgData = image.jpegData(compressionQuality: 0.75) ?? Data()
        let parameters = ["actid": actId, "title": self.captionTextField.text ?? ""] //Optional for extra parameter
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "photo",fileName: "\(User.shared.profile?.username ?? "")_\(Date().dateToStringUpload()).jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            } //Optional for extra parameters
        }, to: "\(String.BaseApiUrl)/activity/upload_photo", method: .post, headers: ["x-access-token":User.shared.header ?? ""]) { (result) in
            switch result {
            case .success(let upload, _, _):
                self.activityIndicatorEnd()
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    NotificationCenter.default.post(name: Notification.Name("updatePhotos"), object: nil, userInfo: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let encodingError):
                self.activityIndicatorEnd()
                print("error upload =\(encodingError.localizedDescription)")
            }
        }
    }


}
